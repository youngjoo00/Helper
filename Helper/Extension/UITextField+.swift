//
//  TextField+.swift
//  ReadingHaracoon
//
//  Created by youngjoo on 3/15/24.
//

import UIKit
import RxSwift

extension UITextField {
    func addLeftPadding() {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = ViewMode.always
    }
}

// MARK: - Rx
extension Reactive where Base: UITextField {
    var becomeFirstResponder: Binder<Void> {
        return Binder(self.base) { textField, _ in
            textField.becomeFirstResponder()
        }
    }
}

