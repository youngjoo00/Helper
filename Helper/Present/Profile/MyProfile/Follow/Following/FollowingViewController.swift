//
//  FollowingViewController.swift
//  Helper
//
//  Created by youngjoo on 4/27/24.
//

import UIKit
import RxSwift
import RxCocoa

final class FollowingViewController: BaseViewController {

    private let mainView = SearchView()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
