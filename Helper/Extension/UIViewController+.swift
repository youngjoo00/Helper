//
//  UIViewController+Ex.swift
//  LSLPBasic
//
//  Created by jack on 2024/04/09.
//

import UIKit
import RxSwift
import RxCocoa

// MARK: - Rx
extension Reactive where Base: UIViewController {
    var viewDidLoad: ControlEvent<Void> {
        let source = self.methodInvoked(#selector(Base.viewDidLoad)).map { _ in }
        return ControlEvent(events: source)
    }
    
    var viewWillAppear: ControlEvent<Void> {
        let source = self.methodInvoked(#selector(Base.viewWillAppear)).map { _ in }
        return ControlEvent(events: source)
    }
}
