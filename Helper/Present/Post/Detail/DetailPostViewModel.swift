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
    }
    
    struct Output {
        let nickname: Driver<String>
        let regDate: Driver<String>
        let files: Driver<[String]>
        let title: Driver<String>
        let category: Driver<String>
        let hashTag: Driver<String>
        let feature: Driver<String>
        let region: Driver<String>
        let locate: Driver<String>
        let date: Driver<String>
        let storage: Driver<[String]>
        //let comments: Driver<[Comments]>
        let errorMessage: Driver<String>
    }
    
    func transform(input: Input) -> Output {
        
        let postInfo = PublishSubject<PostResponse.FetchPost>()
        let errorMessage = PublishRelay<String>()
        
        input.postID
            .flatMap { NetworkManager.shared.callAPI(type: PostResponse.FetchPost.self, router: Router.post(.postID(id: $0))) }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let data):
                    postInfo.onNext(data)
                case .fail(let fail):
                    errorMessage.accept(fail.localizedDescription)
                    print(fail.localizedDescription)
                }
            }
            .disposed(by: disposeBag)
        
        let nickname = postInfo
            .map { $0.creator.nick }
            .asDriver(onErrorJustReturn: "")
        
        let regDate = postInfo
            .map { $0.createdAt }
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
            .map { $0.feature }
            .asDriver(onErrorJustReturn: "")
        
        let region = postInfo
            .map { String($0.productId.split(separator: "_")[0]) }
            .asDriver(onErrorJustReturn: "")
        
        let locate = postInfo
            .map { $0.locate }
            .asDriver(onErrorJustReturn: "")
        
        let date = postInfo
            .map { $0.date }
            .asDriver(onErrorJustReturn: "")
        
        let storage = postInfo
            .map { $0.storage }
            .asDriver(onErrorJustReturn: [])
        
//        let comments = postInfo
//            .map { $0.comments }
//            .asDriver(onErrorJustReturn: [])
        
        return Output(nickname: nickname,
                      regDate: regDate,
                      files: files,
                      title: title,
                      category: category,
                      hashTag: hashTag,
                      feature: feature,
                      region: region,
                      locate: locate,
                      date: date,
                      storage: storage,
                      //comments: comments,
                      errorMessage: errorMessage.asDriver(onErrorJustReturn: "알 수 없는 오류입니다"))
    }
}
