//
//  UIScrollView.swift
//  Helper
//
//  Created by youngjoo on 4/22/24.
//

import RxSwift
import RxCocoa
import UIKit

// MARK: - Rx
extension Reactive where Base: UIScrollView {
    func reachedBottom(from space: CGFloat = 0.0) -> ControlEvent<Void> {
        let source = contentOffset.map { [weak base] contentOffset in
            guard let base = base else { return false }
            let visibleHeight = base.frame.height - base.contentInset.top - base.contentInset.bottom
            let y = contentOffset.y + base.contentInset.top
            let threshold = base.contentSize.height - visibleHeight - space - 100
            return y >= threshold
        }
        .distinctUntilChanged()
        .filter { $0 }
        .map { _ in () }
        return ControlEvent(events: source)
    }
}

