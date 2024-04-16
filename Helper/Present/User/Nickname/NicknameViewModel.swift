//
//  NicknameViewModel.swift
//  SeSACRxThreads
//
//  Created by youngjoo on 4/4/24.
//

import Foundation
import RxSwift
import RxCocoa

final class NicknameViewModel: ViewModelType {
    
    var disposeBag: RxSwift.DisposeBag = .init()

    struct Input {
        let nickname: Observable<String>
        let nextButtonTap: ControlEvent<Void>
    }
    
    struct Output {
        let isValid: Driver<Bool>
        let description: Driver<String>
        let nextButtonTapTrigger: Driver<Void>
    }
    
    func transform(input: Input) -> Output {
        
        let nextButtonTapTrigger = PublishRelay<Void>()
        
        let isValid = input.nickname
            .map { $0.count >= 2 }
        
        let description = isValid
            .map { $0 ? "" : "닉네임은 최소 두 글자 이상입니다" }
        
        input.nextButtonTap
            .withLatestFrom(input.nickname)
            .subscribe(with: self) { owner, nickname in
                SignUpManager.shared.nick = nickname
                nextButtonTapTrigger.accept(())
            }
            .disposed(by: disposeBag)
        
        // 여기까지만 회원가입할지 고민
//        input.nextButtonTap
//            .withLatestFrom(input.nickname) { first, second in
//                RequestModel.Join(email: SignUp.shared.email,
//                            password: SignUp.shared.password,
//                            nick: second,
//                            phone: nil,
//                            birthday: nil)
//            }
//            .flatMap { NetworkManager.shared.callAPI(type: ResponseModel.Join.self, router: .join(query: $0)) }
//            .subscribe(with: self) { owner, result in
//                switch result {
//                case .success(let data):
//                    print(data)
//                case .fail(let fail):
//                    print(fail)
//                case .errorMessage(let message):
//                    print(message)
//                }
//            }
//            .disposed(by: disposeBag)
        
        return Output(isValid: isValid.asDriver(onErrorJustReturn: false),
                      description: description.asDriver(onErrorJustReturn: ""),
                      nextButtonTapTrigger: nextButtonTapTrigger.asDriver(onErrorJustReturn: ()))
    }
}
