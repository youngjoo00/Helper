//
//  WirtePostVIewModel.swift
//  Helper
//
//  Created by youngjoo on 4/16/24.
//

import Foundation
import RxSwift
import RxCocoa

final class WritePostViewModel: ViewModelType {
    
    var disposeBag: RxSwift.DisposeBag = .init()
    
    struct Input {
        let dataList: PublishSubject<[Data]>
    }
    
    struct Output {
        
    }
    
    func transform(input: Input) -> Output {
        
        input.dataList
            .flatMap { NetworkManager.shared.imageUpload(type: PostResponse.FilesModel.self, router: Router.post(.uploadImage), imageDataList: $0) }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let data):
                    print(data.files)
                case .fail(let fail):
                    print(fail.localizedDescription)
                }
            }
            .disposed(by: disposeBag)
        
        return Output()
    }
}
