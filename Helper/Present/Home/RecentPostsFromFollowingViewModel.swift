//
//  RecentPostsFromFollowingViewModel.swift
//  Helper
//
//  Created by youngjoo on 5/3/24.
//

import Foundation
import RxSwift
import RxCocoa

final class RecentPostsFromFollowingViewModel: ViewModelType {
    
    var disposeBag: RxSwift.DisposeBag = .init()
    
    struct Input {
        let fetchPostsTrigger: Observable<Void>
    }
    
    struct Output {
        let posts: Driver<[PostResponse.FetchPost]>
        let errorToastMessage: Driver<String>
    }
    
    func transform(input: Input) -> Output {
   
        let posts: BehaviorRelay<[PostResponse.FetchPost]> = BehaviorRelay(value: [])
        let errorToastMessage = PublishRelay<String>()
        let isRefreshControlLoading = PublishRelay<Bool>()
        
        let info = EventManager.shared.myProfileInfo
            .compactMap { $0 }
        
        input.fetchPostsTrigger
            .withLatestFrom(info)
            .flatMap { info in
                // 1. 팔로잉 UserID List 생성
                let followingUserIDList = info.following.map { $0.userID }
                
                // 2. 리스트를 순회하며 일주일안에 생성된 가장 최근 게시물 한개를 가져옴
                let postList = followingUserIDList.map { userID -> Observable<PostResponse.FetchPost?> in
                    NetworkManager.shared.callAPI(type: PostResponse.Posts.self, router: Router.post(.otherUserFetchPosts(next: "", userID: userID)))
                        .map { result -> PostResponse.FetchPost? in
                            switch result {
                            case .success(let data):
                                guard let recentPost = data.data.first,
                                      let weekAgo = Calendar.current.date(byAdding: .day, value: -7, to: .now) else { return nil }
                                let regDate = DateManager.shared.formatStringToDate(recentPost.createdAt)
                                
                                return regDate >= weekAgo ? recentPost : nil
                            case .fail(let fail):
                                return nil
                            }
                        }
                        .asObservable() // 싱글형태를 옵저버블로 변환해서 반환타입을 옵저버블로 맞춰줌
                }
               
                // 3. 모든 네트워크 통신 결과를 병합해서 최신순으로 정렬
                let sortedPosts = Observable.zip(postList)
                    .map { posts in
                        posts.compactMap { $0 }
                            .sorted { $0.createdAt > $1.createdAt }
                    }

                // 4. 결과를 반환하고, 최종적으로 아래에서 posts 에 이벤트 방출
                return sortedPosts
            }
            .subscribe(with: self) { owner, recentPost in
                posts.accept(recentPost)
                isRefreshControlLoading.accept(false)
            }
            .disposed(by: disposeBag)
        
        return Output(
            posts: posts.asDriver(),
            errorToastMessage: errorToastMessage.asDriver(onErrorJustReturn: "알 수 없는 오류입니다.")
        )
    }
}
