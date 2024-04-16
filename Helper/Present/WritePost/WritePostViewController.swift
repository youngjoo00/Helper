//
//  WritePostViewController.swift
//  Helper
//
//  Created by youngjoo on 4/16/24.
//

import UIKit
import RxSwift
import RxCocoa
import PhotosUI

final class WritePostViewController: BaseViewController {

    private let mainView = WritePostView()
    var selectedImages: [UIImage] = []
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print(selectedImages)
        NetworkManager.shared.callAPI(type: PostResponse.Files.self, router: Router.post(.uploadImage))
    }
}

