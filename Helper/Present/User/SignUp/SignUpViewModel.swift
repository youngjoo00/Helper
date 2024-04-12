//
//  SignUpViewModel.swift
//  SeSACRxThreads
//
//  Created by youngjoo on 4/3/24.
//

import RxSwift
import RxCocoa

final class SignUpViewModel: ViewModelType {
    
    var disposeBag: DisposeBag = .init()
    
    struct Input {
        let email: Observable<String>
        let validationButtonTap: ControlEvent<Void>
        let nextButtonTapped: ControlEvent<Void>
    }
    
    struct Output {
        let validEmail: Driver<Bool>
        let nextButtonTapped: Driver<String>
    }
    
    func transform(input: Input) -> Output {
        
        let validEmail = PublishRelay<Bool>()
        let nextButtonTapped = input.nextButtonTapped
            .withLatestFrom(input.email)
        
        input.validationButtonTap
            .debug()
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(input.email)
            .map { RequestModel.ValidationEmail(email: $0) }
            .flatMap { NetworkManager.shared.callAPI(type: ResponseModel.ValidationEmail.self, router: .validationEmail(query: $0)) }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let data):
                    validEmail.accept(true)
                case .fail(let fail):
                    validEmail.accept(false)
                case .errorMessage(let error):
                    validEmail.accept(false)
                }
            } onDisposed: { _ in
                print("buttonDispose 됨!")
            }
            .disposed(by: disposeBag)

        

        return Output(
            validEmail: validEmail.asDriver(onErrorJustReturn: false),
            nextButtonTapped: nextButtonTapped.asDriver(onErrorJustReturn: "")
        )
    }
    
}

//extension SignUpViewModel {
//    
//    private func emailTextValid(_ text: String) {
//        let isValid = validateEmail(text)
//        
//        outputValidText.accept(isValid ? "" : "유효한 형식이 아닙니다.")
//        outputValidButton.accept(isValid)
//        
//        guard isValid else {
//            return outputValidNextButton.accept(false)
//        }
//        
//    }
//}
