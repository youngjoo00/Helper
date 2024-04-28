//
//  WriteFeedViewModel.swift
//  Helper
//
//  Created by youngjoo on 4/28/24.
//

import Foundation
import RxSwift
import RxCocoa

final class WriteFeedViewModel: ViewModelType {
    
    var disposeBag: RxSwift.DisposeBag = .init()
    
    struct Input {
        let postMode: Observable<PostMode>
        let dataList: PublishSubject<[Data]>
        let title: Observable<String>
        let hashTag: Observable<String>
        let completeButtonTap: ControlEvent<Void>
    }
    
    struct Output {
        let errorAlertMessage: Driver<String>
        let errorToastMessage: Driver<String>
        let isWriteComplete: Driver<String>
//        let postInfo: Driver<PostResponse.FetchPost>
        let files: Driver<[String]>
    }
    
    func transform(input: Input) -> Output {
        
        let errorAlertMessage = PublishRelay<String>()
        let errorToastMessage = PublishRelay<String>()
        let files = BehaviorRelay<[String]>(value: [])
        let isWriteComplete = PublishRelay<String>()

        //        let postInfo = input.postInfo
//            .compactMap { $0 }
        
//        postInfo
//            .subscribe(onNext: { data in
//                files.accept(data.files)
//            })
//            .disposed(by: disposeBag)
        
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
        
        // title 이 비어있으면 안됨
        // Request Model
        let requestModel = Observable.combineLatest(input.title, files)
            .withLatestFrom(input.hashTag) { firstValue, hashTag in
                let (title, files) = firstValue
                
                // 일단 작성요청 모델 통일
                return PostRequest.Write(
                    title: title,
                    hashTag: hashTag,
                    feature: "",
                    locate: "",
                    date: "",
                    phone: "",
                    content: "",
                    product_id: HelperString.productID,
                    files: files
                )
            }
       
        
        let createAPI = PublishSubject<PostRequest.Write>()
        //let updateAPI = PublishSubject<(PostRequest.Feed, String)>()

        //let requestData = Observable.combineLatest(requestModel, input.postMode, input.postInfo)
        
        input.completeButtonTap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(requestModel)
            .subscribe(with: self) { owner, requestModel in
                if requestModel.title.isEmpty {
                    errorToastMessage.accept("내용은 필수입니다.")
                } else {
                    createAPI.onNext(requestModel)
                }
            }
            .disposed(by: disposeBag)
        
        createAPI
            .flatMap { NetworkManager.shared.callAPI(type: PostResponse.FetchPost.self, router: Router.post(.create(query: $0))) }
            .subscribe(with: self) { owner, reslut in
                switch reslut {
                case .success:
                    isWriteComplete.accept("작성")
                case .fail(let error):
                    errorAlertMessage.accept(error.localizedDescription)
                }
            }
            .disposed(by: disposeBag)
        
//        updateAPI
//            .flatMap { requestModel, postID in
//                NetworkManager.shared.callAPI(type: PostResponse.FetchPost.self, router: Router.post(.update(query: requestModel, id: postID)))
//            }
//            .subscribe(with: self) { owner, reslut in
//                switch reslut {
//                case .success:
//                    isWriteComplete.accept("수정")
//                case .fail(let error):
//                    errorAlertMessage.accept(error.localizedDescription)
//                }
//            }
//            .disposed(by: disposeBag)

        return Output(
            errorAlertMessage: errorAlertMessage.asDriver(onErrorJustReturn: "알 수 없는 오류입니다."),
            errorToastMessage: errorToastMessage.asDriver(onErrorJustReturn: "알 수 없는 오류입니다."),
            isWriteComplete: isWriteComplete.asDriver(onErrorJustReturn: "알 수 없는 오류입니다."),
//            postInfo: postInfo.asDriver(onErrorDriveWith: .empty()),
            files: files.asDriver(onErrorJustReturn: [])
        )
    }
}
