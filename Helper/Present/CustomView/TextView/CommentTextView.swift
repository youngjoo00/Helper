//
//  CommentTextView.swift
//  Helper
//
//  Created by youngjoo on 5/4/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class CommentTextView: UITextView {

    private let disposeBag = DisposeBag()

    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureView() {
        textColor = UIColor.black
        layer.cornerRadius = 10
        layer.borderWidth = 1
        layer.borderColor = UIColor.black.cgColor
        textContainer.lineFragmentPadding = 10
        font = .systemFont(ofSize: 15)
    }
}

