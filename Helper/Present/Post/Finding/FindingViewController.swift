//
//  PostViewController.swift
//  Helper
//
//  Created by youngjoo on 4/13/24.
//

import UIKit
import RxSwift
import RxCocoa

final class FindingViewController: BaseViewController {

    private let mainView = FindingView()
    private let viewModel = FindingViewModel()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func bind() {
        let input = FindingViewModel.Input()
        
        let output = viewModel.transform(input: input)
    }
}

extension FindingViewController {
    
}
