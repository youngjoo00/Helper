//
//  PaymentViewController.swift
//  Helper
//
//  Created by youngjoo on 5/4/24.
//

import UIKit
import iamport_ios
import WebKit
import SnapKit
import RxSwift

final class PaymentViewController: BaseViewController {
    
    private let mainView = PaymentView()
    private let viewModel: PaymentViewModel
    
    let viewDidLoadTrigger = PublishSubject<Void>()
    
    init(postID: String, price: String) {
        self.viewModel = .init(postID: postID, price: price)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewDidLoadTrigger.onNext(())
    }
    
    // 1. viewdidload
    // 2. 만들어진 값 방출
    // 3. output 에서 값 갖고 호출
    // 4. 리스폰스 다시 뷰모델로
    // 5. 네트워크 호출해서 결제맞는지 확인
    // 6. 맞으면 돌아와서 성공메세지
    override func bind() {
        
        let iamportResponseSubject = PublishSubject<IamportResponse>()
        
        let input = PaymentViewModel.Input(
            viewDidLoadTrigger: viewDidLoadTrigger,
            iamportResponseSubject: iamportResponseSubject
        )
        
        let output = viewModel.transform(input: input)
        
        output.paymentData
            .drive(with: self) { owner, paymentData in
                Iamport.shared.paymentWebView(
                    webViewMode: owner.mainView.wkWebView,
                    userCode: PrivateKey.paymentUserCode.rawValue,
                    payment: paymentData) { iamportResponse in
                        if let response = iamportResponse,
                            let success = response.success,
                            success {
                            iamportResponseSubject.onNext(response)
                        } else {
                            owner.navigationController?.popViewController(animated: true)
                        }
                    }
            }
            .disposed(by: disposeBag)
        
        output.resultMessage
            .drive(with: self) { owner, message in
                owner.showAlert(title: nil, message: message) {
                    owner.navigationController?.popViewController(animated: true)
                }
            }
            .disposed(by: disposeBag)
        
    }
}
