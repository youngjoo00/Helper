//
//  BaseViewController.swift
//  SeSACRxThreads
//
//  Created by youngjoo on 3/28/24.
//

import UIKit
import RxSwift
import Toast

class BaseViewController: UIViewController {
    
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        bind()
        configureNavigationBackButton()
    }

    func showTaost(_ message: String) {
        view.makeToast(message, duration: 1.5, position: .center)
    }
    
    func bind() { }
    
    func configureNavigationBackButton() {
        // 백버튼 처리
        self.navigationController?.navigationBar.tintColor = Color.black
        self.navigationController?.navigationBar.topItem?.title = ""
    }
}
