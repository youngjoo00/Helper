//
//  PaymentViewModel.swift
//  Helper
//
//  Created by youngjoo on 5/4/24.
//

import Foundation
import RxSwift
import RxCocoa
import iamport_ios

final class PaymentViewModel: ViewModelType {
    
    var disposeBag: RxSwift.DisposeBag = .init()
    
    private let postID: String
    private let price: String
    
    init(postID: String, price: String) {
        self.postID = postID
        self.price = price
    }
    
    struct Input {
        let viewDidLoadTrigger: Observable<Void>
        let iamportResponseSubject: Observable<IamportResponse>
    }
    
    struct Output {
        let paymentData: Driver<IamportPayment>
        let resultMessage: Driver<String>
    }

    func transform(input: Input) -> Output {
    
        let resultMessage = PublishRelay<String>()
        
        let paymentData = input.viewDidLoadTrigger
            .withUnretained(self)
            .map { owner, _ in
                IamportPayment(
                    pg: PG.html5_inicis.makePgRawName(pgId: "INIpayTest"),
                    merchant_uid: "ios_\(PrivateKey.sesac.rawValue)_\(Int(Date().timeIntervalSince1970))",
                    amount: owner.price)
                .then {
                    $0.pay_method = PayMethod.card.rawValue
                    $0.name = "Helper_Test1"
                    $0.buyer_name = "권영주"
                    $0.app_scheme = "Helper"
                }
            }
        
        input.iamportResponseSubject
            .withUnretained(self)
            .map { owner, response in
                PaymentRequest.Validation(impUID: response.imp_uid ?? "",
                                          postID: owner.postID,
                                          productName: "Helper1",
                                          price: Int(owner.price) ?? 0) }
            .flatMap {
                NetworkManager.shared.callAPI(type: PaymentResponse.PaymentData.self,
                                              router: Router.payment(.validation(query: $0)))
            }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let data):
                    resultMessage.accept("사례금 전송이 성공적으로 완료되었습니다")
                    print(data)
                case .fail(let fail):
                    resultMessage.accept("사례금 전송에 실패했습니다")
                    print(fail.localizedDescription)
                }
            }
            .disposed(by: disposeBag)
        
        return Output(
            paymentData: paymentData.asDriver(onErrorDriveWith: .empty()), 
            resultMessage: resultMessage.asDriver(onErrorJustReturn: "알 수 없는 오류입니다.")
        )
    }
}
