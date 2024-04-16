//
//  WritePostViewController.swift
//  Helper
//
//  Created by youngjoo on 4/16/24.
//

import UIKit
import RxSwift
import RxCocoa

final class WritePostViewController: BaseViewController {

    private let mainView = WritePostView()
    private let viewModel = WritePostViewModel()
    
    private let dataListSubject = PublishSubject<[Data]>()
    
    var selectedImages: [UIImage] = []
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        var dataList: [Data] = []
        
        for image in selectedImages {
            if let data = image.pngData() {
                dataList.append(data)
            }
        }
        dataListSubject.onNext(dataList)
    }
    
    override func bind() {
        let input = WritePostViewModel.Input(dataList: dataListSubject)
        
        let output = viewModel.transform(input: input)
    }
}

