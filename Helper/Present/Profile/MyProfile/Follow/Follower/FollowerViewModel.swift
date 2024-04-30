//
//  FollowerViewModel.swift
//  Helper
//
//  Created by youngjoo on 4/27/24.
//

import Foundation
import RxSwift
import RxCocoa

final class FollowerViewModel: ViewModelType {
    
    var disposeBag: RxSwift.DisposeBag = .init()
    
    struct Input {
        
    }
    
    struct Output {
        let followers: Driver<[UserResponse.Follow]>
    }
    
    func transform(input: Input) -> Output {
        
        let followers = BehaviorRelay<[UserResponse.Follow]>(value: [])
        
        EventManager.shared.myProfileInfo
            .compactMap { $0 }
            .subscribe(with: self) { owner, data in
                followers.accept(data.followers)
                // 근데 만약에 팔로워인데 내가 팔로우를 안한 유저라면 팔로우 버튼이 보이게끔
            }
            .disposed(by: disposeBag)
        
        return Output(
            followers: followers.asDriver(onErrorJustReturn: [])
        )
    }
}
