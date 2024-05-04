//
//  DetailFeedViewModel.swift
//  Helper
//
//  Created by youngjoo on 4/28/24.
//

import Foundation
import RxSwift
import RxCocoa

final class DetailFeedViewModel: ViewModelType {
    
    var disposeBag: RxSwift.DisposeBag = .init()
    
    struct Input {
        let feedID: Observable<String>
        let comment: Observable<String>
        let commentButtonTap: ControlEvent<Void>
        let feedDeleteTap: Observable<Void>
        let feedEditTap: Observable<Void>
        let storageButtonTap: ControlEvent<Void>
        let commentDeleteTap: Observable<String>
        let profileTapGesture: Observable<Void>
    }
    
    struct Output {
        let checkedUserID: Driver<Bool>
        let profileImage: Driver<String>
        let nickname: Driver<String>
        let regDate: Driver<String>
        let files: Driver<[String]>
        let title: Driver<String>
        let hashTag: Driver<String>
        let storage: Driver<Bool>
        let comments: Driver<[Comments]>
        let commentsCount: Driver<String>
        let feedDeleteSuccess: Driver<Void>
        let feedEditTap: Driver<PostResponse.FetchPost>
        let errorAlertMessage: Driver<String>
        let errorToastMessage: Driver<String>
        let storageSuccess: Driver<String>
        let commentCreateSuccess: Driver<Void>
        let commentDeleteSuccess: Driver<Void>
        let profileTapGesture: Driver<String>
        let adjustTextViewHeight: Driver<Void>
    }
    
    func transform(input: Input) -> Output {
        
        let feedInfo = PublishSubject<PostResponse.FetchPost>()
        let fetchInfoTrigger = PublishSubject<Void>()
        let commentCreateSuccess = PublishRelay<Void>()
        let commentDeleteSuccess = PublishRelay<Void>()
        let storageSuccess = PublishRelay<Bool>()
        let postDeleteSuccess = PublishRelay<Void>()
        let errorAlertMessage = PublishRelay<String>()
        let errorToastMessage = PublishRelay<String>()
        
        let fetchTrigger = Observable.merge(input.feedID.map { _ in }, 
                                            fetchInfoTrigger)
            .withLatestFrom(input.feedID)
        
        // 네트워크 통신 - postInfo
        fetchTrigger
            .flatMap { NetworkManager.shared.callAPI(type: PostResponse.FetchPost.self, router: Router.post(.postID(id: $0))) }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let data):
                    feedInfo.onNext(data)
                case .fail(let fail):
                    errorAlertMessage.accept(fail.localizedDescription)
                    print(fail.localizedDescription)
                }
            }
            .disposed(by: disposeBag)
        
        // 댓글 요청 구조체 생성
        let commentRequest = Observable.combineLatest(input.feedID, input.comment) { id, comment in
            return CommentRequest.Create(postID: id, content: CommentRequest.Content(content: comment))
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
            .withLatestFrom(feedInfo) { commentID, postInfo in
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
        input.feedDeleteTap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(input.feedID)
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
            .withLatestFrom(Observable.combineLatest(input.feedID, feedInfo))
            .flatMap { feedID, postInfo in
                let state = postInfo.storage.listCheckedUserID
                return NetworkManager.shared.callAPI(type: PostResponse.StorageStatus.self, router: Router.post(.storage(query: PostRequest.StorageStatus(storageStatus: !state), id: feedID)))
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
        
        let feedEditTap = input.feedEditTap
            .withLatestFrom(feedInfo)
            .asDriver(onErrorDriveWith: .empty())
        
        // MARK: - output Info
        let checkedUserID = feedInfo
            .map { $0.creator.userID.checkedUserID }
            .map { !$0 }
            .asDriver(onErrorJustReturn: false)

        let profileImage = feedInfo
            .map { $0.creator.profileImage }
            .asDriver(onErrorJustReturn: "")
        
        let nickname = feedInfo
            .map { $0.creator.nick }
            .asDriver(onErrorJustReturn: "")
        
        let regDate = feedInfo
            .map { DateManager.shared.dateFormat($0.createdAt) }
            .asDriver(onErrorJustReturn: "")
        
        let files = feedInfo
            .map { $0.files }
            .asDriver(onErrorJustReturn: [])
        
        let title = feedInfo
            .map { $0.title }
            .asDriver(onErrorJustReturn: "")
        
        let hashTag = feedInfo
            .map { $0.hashTags[0] }
            .asDriver(onErrorJustReturn: "")
        
        let commentsCount = feedInfo
            .map { "댓글 \($0.comments.count)" }
            .asDriver(onErrorJustReturn: "")
        
        let comments = feedInfo
            .map { $0.comments }
            .asDriver(onErrorJustReturn: [])
        
        let storage = feedInfo
            .map { $0.storage.listCheckedUserID }
            .asDriver(onErrorJustReturn: false)
        
        let profileTapGesture = input.profileTapGesture
            .withLatestFrom(feedInfo)
            .map { $0.creator.userID }
            .asDriver(onErrorJustReturn: "")
        
        return Output(
            checkedUserID: checkedUserID,
            profileImage: profileImage,
            nickname: nickname,
            regDate: regDate,
            files: files,
            title: title,
            hashTag: hashTag,
            storage: storage,
            comments: comments,
            commentsCount: commentsCount,
            feedDeleteSuccess: postDeleteSuccess.asDriver(onErrorDriveWith: .empty()),
            feedEditTap: feedEditTap,
            errorAlertMessage: errorAlertMessage.asDriver(onErrorJustReturn: "알 수 없는 오류입니다"),
            errorToastMessage: errorToastMessage.asDriver(onErrorJustReturn: "알 수 없는 오류입니다"),
            storageSuccess: storageSuccess.map { $0 ? "게시글을 저장했어요!" : "게시글 저장을 취소했어요!" }.asDriver(onErrorDriveWith: .empty()),
            commentCreateSuccess: commentCreateSuccess.asDriver(onErrorDriveWith: .empty()),
            commentDeleteSuccess: commentDeleteSuccess.asDriver(onErrorDriveWith: .empty()),
            profileTapGesture: profileTapGesture,
            adjustTextViewHeight: input.comment.map { _ in }.asDriver(onErrorJustReturn: ())
        )
    }
}
