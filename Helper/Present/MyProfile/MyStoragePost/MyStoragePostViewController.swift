//
//  MyStoragePostViewController.swift
//  Helper
//
//  Created by youngjoo on 4/13/24.
//

import UIKit
import RxSwift
import RxCocoa

final class MyStoragePostViewController: BaseViewController {

    private let mainView = MyStoragePostView()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
