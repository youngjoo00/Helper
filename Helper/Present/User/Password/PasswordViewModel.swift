//
//  PasswordViewModel.swift
//  SeSACRxThreads
//
//  Created by youngjoo on 4/3/24.
//

import Foundation
import RxSwift
import RxCocoa

final class PasswordViewModel: ViewModelType {

    var disposeBag: DisposeBag = .init()
    
    struct Input {
        let password: Observable<String>
        let nextButtonTap: ControlEvent<Void>
    }
    
    struct Output {
        let valid: Driver<Bool>
        let description: Driver<String>
        let nextButtonTap: Driver<String>
    }
    
    func transform(input: Input) -> Output {
        
        let nextButtonTap = input.nextButtonTap
            .withLatestFrom(input.password)
        
        let valid = input.password
            .map { $0.count >= 4 }
            .asDriver(onErrorJustReturn: false)
        
        let description = valid
            .map { $0 ? "" : "비밀번호는 최소 4자 이상입니다" }
            .asDriver(onErrorJustReturn: "")
        
        return Output(valid: valid, 
                      description: description,
                      nextButtonTap: nextButtonTap.asDriver(onErrorJustReturn: "")
        )
    }
}
