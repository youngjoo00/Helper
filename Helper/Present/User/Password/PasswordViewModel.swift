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
        let viewWillAppearTrigger: ControlEvent<Void>
        let password: Observable<String>
        let secondPassword: Observable<String>
        let nextButtonTap: ControlEvent<Void>
    }
    
    struct Output {
        let viewWillAppearTrigger: Driver<Void>
        let description: Driver<String>
        let secondDescription: Driver<String>
        let enableButton: Driver<Bool>
        let nextButtonTapTrigger: Driver<Void>
    }
    
    func transform(input: Input) -> Output {
        
        let nextButtonTapTrigger = PublishRelay<Void>()
        
        let isValid = input.password
            .map { $0.count >= 4 }
        
        let description = isValid
            .map { $0 ? "" : "비밀번호는 최소 4자 이상입니다" }
        
        let isSecondValid = Observable.combineLatest(input.password, input.secondPassword)
            .map { $0 == $1 }
        
        let secondDescription = isSecondValid
            .map { $0 ? "" : "비밀번호가 일치하지 않습니다" }
                
        let enableButton = Observable.combineLatest(isValid, isSecondValid)
            .map { $0 && $1 }
        
        input.nextButtonTap
            .withLatestFrom(input.password)
            .subscribe(with: self) { owner, password in
                UserProfileManager.shared.password = password
                nextButtonTapTrigger.accept(())
            }
            .disposed(by: disposeBag)
        
        return Output(
            viewWillAppearTrigger: input.viewWillAppearTrigger.asDriver(), 
            description: description.asDriver(onErrorJustReturn: "알 수 없는 오류입니다."),
            secondDescription: secondDescription.asDriver(onErrorJustReturn: "알 수 없는 오류입니다."),
            enableButton: enableButton.asDriver(onErrorJustReturn: false),
            nextButtonTapTrigger: nextButtonTapTrigger.asDriver(onErrorJustReturn: ())
        )
    }
}
