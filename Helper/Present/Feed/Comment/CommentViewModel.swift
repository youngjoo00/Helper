//
//  CommentViewModel.swift
//  Helper
//
//  Created by youngjoo on 4/28/24.
//

import Foundation
import RxSwift
import RxCocoa

final class CommentViewModel: ViewModelType {
    
    var disposeBag: RxSwift.DisposeBag = .init()
    
    struct Input {
        let postID: Observable<String>
        let fetchPostsTrigger: Observable<Void>
        let reachedBottomTrigger: ControlEvent<Void>
        let comment: Observable<String>
        let commentButtonTap: ControlEvent<Void>
        let commentDeleteTap: Observable<String>
        //let profileTapGesture: Observable<Void>
    }
    
    struct Output {
        let checkedUserID: Driver<Bool>
        let comments: Driver<[Comments]>
        let commentsCount: Driver<String>
        let errorAlertMessage: Driver<String>
        let errorToastMessage: Driver<String>
        let commentCreateSuccess: Driver<Void>
        let commentDeleteSuccess: Driver<Void>
        //let profileTapGesture: Driver<String>
    }
    
    func transform(input: Input) -> Output {
        
        let postInfo = PublishSubject<PostResponse.FetchPost>()
        let fetchInfoTrigger = BehaviorSubject<Void>(value: ())
        let commentCreateSuccess = PublishRelay<Void>()
        let commentDeleteSuccess = PublishRelay<Void>()
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
       
        // MARK: - output Info
        let checkedUserID = postInfo
            .map { $0.creator.userID.checkedUserID }
            .map { !$0 }
            .asDriver(onErrorJustReturn: false)

        let commentsCount = postInfo
            .map { "댓글 \($0.comments.count)" }
            .asDriver(onErrorJustReturn: "")
        
        let comments = postInfo
            .map { $0.comments }
            .asDriver(onErrorJustReturn: [])
        
//        let profileTapGesture = input.profileTapGesture
//            .withLatestFrom(postInfo)
//            .map { $0.creator.userID }
//            .asDriver(onErrorJustReturn: "")
        
        return Output(
            checkedUserID: checkedUserID,
            comments: comments,
            commentsCount: commentsCount,
            errorAlertMessage: errorAlertMessage.asDriver(onErrorJustReturn: "알 수 없는 오류입니다"),
            errorToastMessage: errorToastMessage.asDriver(onErrorJustReturn: "알 수 없는 오류입니다."),
            commentCreateSuccess: commentCreateSuccess.asDriver(onErrorDriveWith: .empty()),
            commentDeleteSuccess: commentDeleteSuccess.asDriver(onErrorDriveWith: .empty())
            //profileTapGesture: profileTapGesture
        )
    }
}
