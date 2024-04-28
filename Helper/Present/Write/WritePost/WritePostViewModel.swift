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
        let date: Observable<Date>
        let phone: Observable<String>
        let content: Observable<String>
        let completeButtonTap: ControlEvent<Void>
    }
    
    struct Output {
        let errorAlertMessage: Driver<String>
        let errorToastMessage: Driver<String>
        let isWriteComplete: Driver<String>
        let postInfo: Driver<PostResponse.FetchPost>
        let files: Driver<[String]>
    }
    
    func transform(input: Input) -> Output {
        
        let errorAlertMessage = PublishRelay<String>()
        let errorToastMessage = PublishRelay<String>()
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
                    errorAlertMessage.accept(fail.localizedDescription)
                    print(fail.localizedDescription)
                }
            }
            .disposed(by: disposeBag)
        
        // 제목이 비어있으면 안됨
        // Request Model Gruop
        let inputGroup1 = Observable.combineLatest(input.title, input.content, input.feature, input.locate, input.date)
            .debug("1번그룹")
        let inputGroup2 = Observable.combineLatest(input.phone, input.category, input.hashTag, input.region, files)
            .debug("2번그룹")
        // 생성 Request
        let requestModel = Observable.combineLatest(inputGroup1, inputGroup2) { group1, group2 in
            let (title, content, feature, locate, date) = group1
            let (phone, category, hashTag, region, files) = group2
            
            return PostRequest.Write(
                title: title,
                hashTag: "#\(hashTag)",
                feature: feature,
                locate: locate,
                date: DateManager.shared.formatDateToString(date: date),
                phone: phone,
                content: content,
                product_id: "\(region)_\(category)",
                files: files)
            }
            .debug("최종 그룹")
       
        // 1. requestModel, postMode 를 가져옴
        // 2. 타이틀이 비어있으면 제목은 필수라고하고 에러처리하면서 끝냄
        // 3. 비어있지 않다면, 포스트 모드가 create 인 경우 -> requestModel 갖고 네트워크 통신
        // 4. update 인 경우 -> postInfo.postID 를 갖고 네트워크 통신
        // 5. 결과를 구독하고 있다가, 포스트 모드에 맞게 complete 에 "작성" / "수정" 이라는 String 이벤트 방출
        let createAPI = PublishSubject<PostRequest.Write>()
        let updateAPI = PublishSubject<(PostRequest.Write, String)>()

        let requestData = Observable.combineLatest(requestModel, input.postMode, input.postInfo)
        
        input.completeButtonTap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(requestData)
            .subscribe(with: self) { owner, requestData in
                if requestData.0.title.isEmpty {
                    errorToastMessage.accept("제목은 필수입니다.")
                } else {
                    switch requestData.1 {
                    case .create:
                        createAPI.onNext(requestData.0)
                    case .update:
                        if let postID = requestData.2?.postID {
                            updateAPI.onNext((requestData.0, postID))
                        }
                    }
                }
            }
            .disposed(by: disposeBag)
        
        createAPI
            .flatMap { requestModel in
                NetworkManager.shared.callAPI(type: PostResponse.FetchPost.self, router: Router.post(.create(query: requestModel)))
            }
            .subscribe(with: self) { owner, reslut in
                switch reslut {
                case .success:
                    isWriteComplete.accept("작성")
                case .fail(let error):
                    errorAlertMessage.accept(error.localizedDescription)
                }
            }
            .disposed(by: disposeBag)
        
        updateAPI
            .flatMap { requestModel, postID in
                NetworkManager.shared.callAPI(type: PostResponse.FetchPost.self, router: Router.post(.update(query: requestModel, id: postID)))
            }
            .subscribe(with: self) { owner, reslut in
                switch reslut {
                case .success:
                    isWriteComplete.accept("수정")
                case .fail(let error):
                    errorAlertMessage.accept(error.localizedDescription)
                }
            }
            .disposed(by: disposeBag)

        return Output(
            errorAlertMessage: errorAlertMessage.asDriver(onErrorJustReturn: "알 수 없는 오류입니다."),
            errorToastMessage: errorToastMessage.asDriver(onErrorJustReturn: "알 수 없는 오류입니다."),
            isWriteComplete: isWriteComplete.asDriver(onErrorJustReturn: "알 수 없는 오류입니다."),
            postInfo: postInfo.asDriver(onErrorDriveWith: .empty()),
            files: files.asDriver(onErrorJustReturn: [])
        )
    }
}
