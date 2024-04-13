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
        let isValid: Driver<Bool>
        let description: Driver<String>
        let nextButtonTapTrigger: Driver<Void>
    }
    
    func transform(input: Input) -> Output {
        
        let nextButtonTapTrigger = PublishRelay<Void>()
        
        input.nextButtonTap
            .withLatestFrom(input.password)
            .subscribe(with: self) { owner, password in
                SignUp.shared.password = password
                nextButtonTapTrigger.accept(())
            }
            .disposed(by: disposeBag)
        
        let isValid = input.password
            .map { $0.count >= 4 }
        
        let description = isValid
            .map { $0 ? "" : "비밀번호는 최소 4자 이상입니다" }
        
        return Output(isValid: isValid.asDriver(onErrorJustReturn: false),
                      description: description.asDriver(onErrorJustReturn: ""),
                      nextButtonTapTrigger: nextButtonTapTrigger.asDriver(onErrorJustReturn: ())
        )
    }
}
