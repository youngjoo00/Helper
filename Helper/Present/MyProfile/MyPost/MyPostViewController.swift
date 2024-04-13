//
//  MyPostViewController.swift
//  Helper
//
//  Created by youngjoo on 4/13/24.
//

import UIKit
import RxSwift
import RxCocoa

final class MyPostViewController: BaseViewController {

    private let mainView = MyPostView()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
