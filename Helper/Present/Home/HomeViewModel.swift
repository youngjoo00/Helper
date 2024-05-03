//
//  HomeViewModel.swift
//  Helper
//
//  Created by youngjoo on 5/4/24.
//

import Foundation
import RxSwift
import RxCocoa

final class HomeViewModel: ViewModelType {
    
    var disposeBag: RxSwift.DisposeBag = .init()
    
    struct Input {
        let refreshControlTrigger: ControlEvent<Void>
    }
    
    struct Output {
        let refreshControlTrigger: Driver<Void>
        let isFollowingEmpty: Driver<Bool>
    }
    
    func transform(input: Input) -> Output {
   
        let info = EventManager.shared.myProfileInfo.compactMap { $0 }
        
        let isFollowingEmpty = info.map {
            $0.following.isEmpty
        }

        return Output(
            refreshControlTrigger: input.refreshControlTrigger.debounce(.seconds(1), scheduler: MainScheduler.instance).asDriver(onErrorJustReturn: ()),
            isFollowingEmpty: isFollowingEmpty.asDriver(onErrorJustReturn: true)
        )
    }
}
