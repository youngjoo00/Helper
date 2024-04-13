//
//  PhoneViewModel.swift
//  Helper
//
//  Created by youngjoo on 4/13/24.
//

import Foundation
import RxSwift
import RxCocoa

final class PhoneViewModel: ViewModelType {
    
    var disposeBag: RxSwift.DisposeBag = .init()

    struct Input {
        let phone: Observable<String>
        let nextButtonTap: ControlEvent<Void>
    }
    
    struct Output {
        let isValid: Driver<Bool>
        let description: Driver<String>
        let nextButtonTapTrigger: Driver<Void>
    }
    
    func transform(input: Input) -> Output {
        
        let nextButtonTapTrigger = PublishRelay<Void>()
        
        let isValid: Observable<Bool> = input.phone
            .map { [weak self] phone in
                guard let self else { return false }
                return self.validatePhone(phone)
            }
        
        let description = isValid
            .map { $0 ? "" : "유효한 휴대폰 번호 형식이 아닙니다." }
        
        input.nextButtonTap
            .withLatestFrom(input.phone)
            .subscribe(with: self) { owner, phone in
                SignUpManager.shared.phone = phone
                nextButtonTapTrigger.accept(())
            }
            .disposed(by: disposeBag)
        
        return Output(isValid: isValid.asDriver(onErrorJustReturn: false),
                      description: description.asDriver(onErrorJustReturn: ""),
                      nextButtonTapTrigger: nextButtonTapTrigger.asDriver(onErrorJustReturn: ()))
    }
}
