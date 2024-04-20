//
//  WirtePostVIewModel.swift
//  Helper
//
//  Created by youngjoo on 4/16/24.
//

import Foundation
import RxSwift
import RxCocoa

final class WritePostViewModel: ViewModelType {
    
    var disposeBag: RxSwift.DisposeBag = .init()
    
    struct Input {
        let postMode: Observable<PostMode>
        let postInfo: Observable<PostResponse.FetchPost?>
        let dataList: PublishSubject<[Data]>
        let hashTag: Observable<String>
        let category: Observable<String>
        let title: Observable<String>
        let feature: Observable<String>
        let region: Observable<String>
        let locate: Observable<String>
        let date: Observable<String>
        let phone: Observable<String>
        let content: Observable<String>
        let completeButtonTap: ControlEvent<Void>
    }
    
    struct Output {
        let errorMessage: Driver<String>
        let isWriteComplete: Driver<String>
        let postInfo: Driver<PostResponse.FetchPost>
        let files: Driver<[String]>
    }
    
    func transform(input: Input) -> Output {
        
        let errorMessage = PublishRelay<String>()
        let files = BehaviorRelay<[String]>(value: [])
        let isWriteComplete = PublishRelay<String>()
        
        let postInfo = input.postInfo
            .compactMap { $0 }
        
        postInfo
            .subscribe(onNext: { data in
                files.accept(data.files)
            })
            .disposed(by: disposeBag)
        
        // 이미지 업로드
        input.dataList
            .flatMap { NetworkManager.shared.imageUpload(type: PostResponse.FilesModel.self, router: Router.post(.uploadImage), imageDataList: $0) }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let data):
                    files.accept(data.files)
                case .fail(let fail):
                    errorMessage.accept(fail.localizedDescription)
                    print(fail.localizedDescription)
                }
            }
            .disposed(by: disposeBag)
        
        // Request Model 생성
        let inputGroup1 = Observable.combineLatest(input.title, input.content, input.feature, input.locate, input.date)
            .debug("")
        let inputGroup2 = Observable.combineLatest(input.phone, input.category, input.hashTag, input.region, files)

        let createRequest = Observable.combineLatest(inputGroup1, inputGroup2) { group1, group2 in
            let (title, content, feature, locate, date) = group1
            let (phone, category, hashTag, region, files) = group2
            
            return PostRequest.Write(
                title: title,
                hashTag: "#\(hashTag)",
                feature: feature,
                locate: locate,
                date: date,
                phone: phone,
                content: content,
                product_id: "\(region)_\(category)",
                files: files)
            }
            
        let updateRequest = Observable.combineLatest(createRequest, postInfo)
        
        // 게시글 작성
        input.completeButtonTap
            .withLatestFrom(createRequest)
            .flatMap { NetworkManager.shared.callAPI(type: PostResponse.FetchPost.self, router: Router.post(.write(query: $0))) }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success:
                    isWriteComplete.accept("작성")
                case .fail(let fail):
                    errorMessage.accept(fail.localizedDescription)
                    print(fail.localizedDescription)
                }
            }
            .disposed(by: disposeBag)
        
        // 게시물 수정
        input.completeButtonTap
            .withLatestFrom(updateRequest)
            .flatMap { requestModel, info in
                NetworkManager.shared.callAPI(type: PostResponse.FetchPost.self, router: Router.post(.update(query: requestModel, id: info.postID)))
            }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success:
                    isWriteComplete.accept("수정")
                case .fail(let fail):
                    errorMessage.accept(fail.localizedDescription)
                    print(fail.localizedDescription)
                }
            }
            .disposed(by: disposeBag)
        
        return Output(
            errorMessage: errorMessage.asDriver(onErrorJustReturn: "알 수 없는 오류입니다."),
            isWriteComplete: isWriteComplete.asDriver(onErrorJustReturn: "알 수 없는 오류입니다."),
            postInfo: postInfo.asDriver(onErrorDriveWith: .empty()),
            files: files.asDriver(onErrorJustReturn: [])
        )
    }
}
