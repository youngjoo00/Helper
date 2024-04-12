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
        let valid: Driver<Bool>
        let description: Driver<String>
        let nextButtonTap: ControlEvent<Void>
    }
    
    func transform(input: Input) -> Output {
        let valid = input.nickname
            .map { $0.count >= 2 }
            .asDriver(onErrorJustReturn: false)
        
        let description = valid
            .map { $0 ? "" : "닉네임은 최소 두 글자 이상입니다" }
            .asDriver()
        
        input.nextButtonTap
            .withLatestFrom(input.nickname) { first, second in
                RequestModel.Join(email: SignUp.shared.email,
                            password: SignUp.shared.password,
                            nick: second,
                            phone: nil,
                            birthday: nil)
            }
            .flatMap { NetworkManager.shared.callAPI(type: ResponseModel.Join.self, router: .join(query: $0)) }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let data):
                    print(data)
                case .fail(let fail):
                    print(fail)
                case .errorMessage(let message):
                    print(message)
                }
            }
            .disposed(by: disposeBag)
        
        return Output(valid: valid,
                      description: description, 
                      nextButtonTap: input.nextButtonTap)
    }
}
