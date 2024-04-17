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
        let isUploadImage: Driver<Void>
        let errorMessage: Driver<String>
        let isWriteComplete: Driver<Void>
    }
    
    func transform(input: Input) -> Output {
        
        let isUploadImage = PublishRelay<Void>()
        let errorMessage = PublishRelay<String>()
        let files = PublishSubject<[String]>()
        let isWriteComplete = PublishRelay<Void>()
        
        // 이미지 업로드
        input.dataList
            .flatMap { NetworkManager.shared.imageUpload(type: PostResponse.FilesModel.self, router: Router.post(.uploadImage), imageDataList: $0) }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let data):
                    isUploadImage.accept(())
                    files.onNext(data.files)
                    print(data.files)
                case .fail(let fail):
                    errorMessage.accept(fail.localizedDescription)
                    print(fail.localizedDescription)
                }
            }
            .disposed(by: disposeBag)
        
        // Request Model 생성
        let inputGroup1 = Observable.combineLatest(input.title, input.content, input.feature, input.locate, input.date)
        let inputGroup2 = Observable.combineLatest(input.phone, input.category, input.hashTag, input.region, files)
        let requestModel = Observable.combineLatest(inputGroup1, inputGroup2) { group1, group2 in
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
            
        // 게시글 작성
        input.completeButtonTap
            .withLatestFrom(requestModel)
            .flatMap { NetworkManager.shared.callAPI(type: PostResponse.FetchPost.self, router: Router.post(.write(query: $0))) }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let data):
                    dump(data)
                    isWriteComplete.accept(())
                case .fail(let fail):
                    errorMessage.accept(fail.localizedDescription)
                    print(fail.localizedDescription)
                }
            }
            .disposed(by: disposeBag)
        
        return Output(isUploadImage: isUploadImage.asDriver(onErrorDriveWith: .empty()),
                      errorMessage: errorMessage.asDriver(onErrorJustReturn: "알 수 없는 오류입니다."),
                      isWriteComplete: isWriteComplete.asDriver(onErrorDriveWith: .empty())
        )
    }
}
