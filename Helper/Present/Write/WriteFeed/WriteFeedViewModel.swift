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
    var postMode: PostMode
    var postInfo: PostResponse.FetchPost?
    var postID: String
    
    init(postID: String = "", postMode: PostMode = .create, postInfo: PostResponse.FetchPost?) {
        self.postMode = postMode
        self.postInfo = postInfo
        self.postID = postID
    }
    
    struct Input {
        let dataList: PublishSubject<[Data]>
        let title: Observable<String>
        let completeButtonTap: ControlEvent<Void>
    }
    
    struct Output {
        let errorAlertMessage: Driver<String>
        let errorToastMessage: Driver<String>
        let isWriteComplete: Driver<String>
        let files: Driver<[String]>
    }
    
    func transform(input: Input) -> Output {
        
        let errorAlertMessage = PublishRelay<String>()
        let errorToastMessage = PublishRelay<String>()
        let files = BehaviorRelay<[String]>(value: [])
        let isWriteComplete = PublishRelay<String>()

        if let postInfo {
            files.accept(postInfo.files)
        }

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
            .map { value in
                let (title, files) = value
                
                // 일단 작성요청 모델 통일
                return PostRequest.Write(
                    title: title,
                    hashTag: "",
                    feature: "",
                    locate: "",
                    date: "",
                    phone: "",
                    content: "",
                    product_id: HelperString.productID,
                    files: files
                )
            }
       
        
        let writeAPI = PublishSubject<PostRequest.Write>()
        
        input.completeButtonTap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(requestModel)
            .subscribe(with: self) { owner, requestModel in
                if requestModel.title.isEmpty {
                    errorToastMessage.accept("내용은 필수입니다.")
                } else {
                    writeAPI.onNext(requestModel)
                }
            }
            .disposed(by: disposeBag)
        
        writeAPI
            .withUnretained(self)
            .flatMap { owner, requestModel in
                switch owner.postMode {
                case .create:
                    NetworkManager.shared.callAPI(type: PostResponse.FetchPost.self, router: Router.post(.create(query: requestModel)))
                case .update:
                    NetworkManager.shared.callAPI(type: PostResponse.FetchPost.self, router: Router.post(.update(query: requestModel, id: owner.postID)))
                }
            }
            .subscribe(with: self) { owner, reslut in
                switch reslut {
                case .success:
                    switch owner.postMode {
                    case .create:
                        isWriteComplete.accept("작성")
                    case .update:
                        isWriteComplete.accept("수정")
                    }
                case .fail(let error):
                    errorAlertMessage.accept(error.localizedDescription)
                }
            }
            .disposed(by: disposeBag)

        return Output(
            errorAlertMessage: errorAlertMessage.asDriver(onErrorJustReturn: "알 수 없는 오류입니다."),
            errorToastMessage: errorToastMessage.asDriver(onErrorJustReturn: "알 수 없는 오류입니다."),
            isWriteComplete: isWriteComplete.asDriver(onErrorJustReturn: "알 수 없는 오류입니다."),
            files: files.asDriver(onErrorJustReturn: [])
        )
    }
}
