//
//  SearchViewController.swift
//  Helper
//
//  Created by youngjoo on 4/13/24.
//

import UIKit
import RxSwift
import RxCocoa

final class SearchViewController: BaseViewController {

    private let mainView = SearchView()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
