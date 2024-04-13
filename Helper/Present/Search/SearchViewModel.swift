//
//  SearchViewModel.swift
//  Helper
//
//  Created by youngjoo on 4/13/24.
//

import Foundation
import RxSwift
import RxCocoa

final class SearchViewModel: ViewModelType {
    
    var disposeBag: RxSwift.DisposeBag = .init()
    
    struct Input {
        
    }
    
    struct Output {
        
    }
    
    func transform(input: Input) -> Output {
        return Output()
    }
}
