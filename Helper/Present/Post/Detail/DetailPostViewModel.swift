//
//  DetailPostViewModel.swift
//  Helper
//
//  Created by youngjoo on 4/18/24.
//

import Foundation
import RxSwift
import RxCocoa

final class DetailPostViewModel: ViewModelType {
    
    var disposeBag: RxSwift.DisposeBag = .init()
    
    struct Input {
        let postID: Observable<String>
        let comment: Observable<String>
        let commentButtonTap: ControlEvent<Void>
        let postDeleteTap: Observable<Void>
        let postEditMenuTap: Observable<Void>
        let storageButtonTap: ControlEvent<Void>
        let commentDeleteTap: Observable<String>
    }
    
    struct Output {
        let checkedUserID: Driver<Bool>
        let nickname: Driver<String>
        let regDate: Driver<String>
        let files: Driver<[String]>
        let title: Driver<String>
        let category: Driver<String>
        let hashTag: Driver<String>
        let feature: Driver<String>
        let regionLocate: Driver<String>
        let date: Driver<String>
        let phone: Driver<String>
        let storage: Driver<Bool>
        let content: Driver<String>
        let comments: Driver<[Comments]>
        let commentsCount: Driver<String>
        let postDeleteSuccess: Driver<Void>
        let errorAlertMessage: Driver<String>
        let errorToastMessage: Driver<String>
        let postEditMenuTap: Driver<PostResponse.FetchPost>
        let storageSuccess: Driver<String>
        let commentCreateSuccess: Driver<Void>
        let commentDeleteSuccess: Driver<Void>
    }
    
    func transform(input: Input) -> Output {
        
        let postInfo = PublishSubject<PostResponse.FetchPost>()
        let fetchInfoTrigger = BehaviorSubject<Void>(value: ())
        let commentCreateSuccess = PublishRelay<Void>()
        let commentDeleteSuccess = PublishRelay<Void>()
        let storageSuccess = PublishRelay<Bool>()
        let postDeleteSuccess = PublishRelay<Void>()
        let errorAlertMessage = PublishRelay<String>()
        let errorToastMessage = PublishRelay<String>()
        
        // 네트워크 통신 - postInfo
        Observable.combineLatest(input.postID, fetchInfoTrigger)
            .flatMap { postID, _ in
                NetworkManager.shared.callAPI(type: PostResponse.FetchPost.self, router: Router.post(.postID(id: postID)))
            }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let data):
                    postInfo.onNext(data)
                case .fail(let fail):
                    errorAlertMessage.accept(fail.localizedDescription)
                    print(fail.localizedDescription)
                }
            }
            .disposed(by: disposeBag)
        
        // 댓글 요청 구조체 생성
        let commentRequest = Observable.combineLatest(input.postID, input.comment) { postID, comment in
            return CommentRequest.Create(postID: postID, content: CommentRequest.Content(content: comment))
        }
        
        // 댓글 등록
        input.commentButtonTap
            .withLatestFrom(input.comment)
            .filter { !$0.isEmpty }
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(commentRequest)
            .flatMap { NetworkManager.shared.callAPI(type: Comments.self, router: Router.comment(.create($0))) }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success:
                    fetchInfoTrigger.onNext(())
                    commentCreateSuccess.accept(())
                case .fail(let fail):
                    errorAlertMessage.accept(fail.localizedDescription)
                    print(fail.localizedDescription)
                }
            }
            .disposed(by: disposeBag)
        
        // 댓글 삭제
        input.commentDeleteTap
            .withLatestFrom(postInfo) { commentID, postInfo in
                return CommentRequest.Delete(postID: postInfo.postID, commentID: commentID)
            }
            .flatMap { NetworkManager.shared.EmptyResponseCallAPI(router: Router.comment(.delete($0))) }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success:
                    fetchInfoTrigger.onNext(())
                    commentDeleteSuccess.accept(())
                case .fail(let fail):
                    errorToastMessage.accept(fail.localizedDescription)
                    print(fail.localizedDescription)
                }
            }
            .disposed(by: disposeBag)
        
        // 게시물 삭제
        input.postDeleteTap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(input.postID)
            .flatMap { NetworkManager.shared.EmptyResponseCallAPI(router: Router.post(.delete(id: $0))) }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success:
                    EventManager.shared.postWriteTrigger.onNext(())
                    postDeleteSuccess.accept(())
                case .fail(let fail):
                    errorAlertMessage.accept(fail.localizedDescription)
                }
            }
            .disposed(by: disposeBag)
        
        // 게시물 저장
        input.storageButtonTap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(Observable.combineLatest(input.postID, postInfo))
            .flatMap { postID, postInfo in
                let state = postInfo.storage.filter { $0.checkedUserID }.count >= 1
                return NetworkManager.shared.callAPI(type: PostResponse.StorageStatus.self, router: Router.post(.storage(query: PostRequest.StorageStatus(storageStatus: !state), id: postID)))
            }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let data):
                    fetchInfoTrigger.onNext(())
                    EventManager.shared.storageTrigger.onNext(())
                    storageSuccess.accept(data.storageStatus)
                case .fail(let fail):
                    errorAlertMessage.accept(fail.localizedDescription)
                }
            }
            .disposed(by: disposeBag)
        
        let postEditMenuTap = input.postEditMenuTap
            .withLatestFrom(postInfo)
            .asDriver(onErrorDriveWith: .empty())
        
        // MARK: - output Info
        let checkedUserID = postInfo
            .map { $0.creator.userID.checkedUserID }
            .map { !$0 }
            .asDriver(onErrorJustReturn: false)

        let nickname = postInfo
            .map { $0.creator.nick }
            .asDriver(onErrorJustReturn: "")
        
        let regDate = postInfo
            .map { DateManager.shared.dateFormat($0.createdAt) }
            .asDriver(onErrorJustReturn: "")
        
        let files = postInfo
            .map { $0.files }
            .asDriver(onErrorJustReturn: [])
        
        let title = postInfo
            .map { $0.title }
            .asDriver(onErrorJustReturn: "")
        
        let category = postInfo
            .map { String($0.productId.split(separator: "_")[1]) }
            .asDriver(onErrorJustReturn: "")
        
        let hashTag = postInfo
            .map { $0.hashTags[0] }
            .asDriver(onErrorJustReturn: "")
        
        let feature = postInfo
            .map { $0.feature.contentEmpty }
            .asDriver(onErrorJustReturn: "")
        
        let regionLocate = postInfo
            .map { "\($0.productId.splitProductID[0] + " " + $0.locate)".contentEmpty }
            .asDriver(onErrorJustReturn: "")
        
        let date = postInfo
            .map { $0.date.contentEmpty }
            .asDriver(onErrorJustReturn: "")
        
        let phone = postInfo
            .map { $0.phone.contentEmpty }
            .asDriver(onErrorJustReturn: "")
        
        let content = postInfo
            .map { $0.content.contentEmpty }
            .asDriver(onErrorJustReturn: "")
        
        let commentsCount = postInfo
            .map { "댓글 \($0.comments.count)" }
            .asDriver(onErrorJustReturn: "")
        
        let comments = postInfo
            .map { $0.comments }
            .asDriver(onErrorJustReturn: [])
        
        let storage = postInfo
            .map { $0.storage.filter { $0.checkedUserID }.count >= 1 }
            .asDriver(onErrorJustReturn: false)
        
        return Output(checkedUserID: checkedUserID,
                      nickname: nickname,
                      regDate: regDate,
                      files: files,
                      title: title,
                      category: category,
                      hashTag: hashTag,
                      feature: feature,
                      regionLocate: regionLocate,
                      date: date, 
                      phone: phone,
                      storage: storage,
                      content: content,
                      comments: comments,
                      commentsCount: commentsCount, 
                      postDeleteSuccess: postDeleteSuccess.asDriver(onErrorDriveWith: .empty()),
                      errorAlertMessage: errorAlertMessage.asDriver(onErrorJustReturn: "알 수 없는 오류입니다"), 
                      errorToastMessage: errorToastMessage.asDriver(onErrorJustReturn: "알 수 없는 오류입니다."),
                      postEditMenuTap: postEditMenuTap,
                      storageSuccess: storageSuccess.map { $0 ? "게시글을 저장했어요!" : "게시글 저장을 취소했어요!" }.asDriver(onErrorDriveWith: .empty()),
                      commentCreateSuccess: commentCreateSuccess.asDriver(onErrorDriveWith: .empty()), 
                      commentDeleteSuccess: commentDeleteSuccess.asDriver(onErrorDriveWith: .empty())
        )
    }
}
