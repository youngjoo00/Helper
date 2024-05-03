//
//  OnlyNumberTextField.swift
//  Helper
//
//  Created by youngjoo on 4/26/24.
//

import UIKit

final class NumberPadTextField: UITextField {
    
    init(placeholderText: String) {
        super.init(frame: .zero)
        
        textColor = Color.black
        placeholder = placeholderText
        borderStyle = .none
        layer.cornerRadius = 10
        layer.borderWidth = 1
        layer.borderColor = Color.black.cgColor
        keyboardType = .numberPad
        addLeftPadding()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
}
