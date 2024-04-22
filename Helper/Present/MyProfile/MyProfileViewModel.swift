//
//  MyProfileViewModel.swift
//  Helper
//
//  Created by youngjoo on 4/13/24.
//

import Foundation
import RxSwift
import RxCocoa

final class MyProfileViewModel: ViewModelType {
    
    var disposeBag: RxSwift.DisposeBag = .init()
    
    struct Input {
        let viewDidLoadTrigger: Observable<Void>
    }
    
    struct Output {
        let nickname: Driver<String>
        let postsID: PublishSubject<[String]>
    }
    
    func transform(input: Input) -> Output {
        
        let profileInfo = PublishRelay<UserResponse.MyProfile>()
        let nickname = PublishRelay<String>()
        let postsID = PublishSubject<[String]>()
        
        // viewDidLoad - myProfile 통신
        input.viewDidLoadTrigger
            .flatMap { NetworkManager.shared.callAPI(type: UserResponse.MyProfile.self, router: Router.user(.myProfile)) }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let data):
                    profileInfo.accept(data)
                case .fail(let fail):
                    print(fail.localizedDescription)
                }
            }
            .disposed(by: disposeBag)

        // 디코딩된 값 방출
        profileInfo
            .subscribe(with: self) { owner, data in
                nickname.accept("\(data.nick)님, 안녕하세요")
                postsID.onNext(data.posts)
            }
            .disposed(by: disposeBag)
        
        return Output(nickname: nickname.asDriver(onErrorJustReturn: ""), 
                      postsID: postsID)
    }
}
