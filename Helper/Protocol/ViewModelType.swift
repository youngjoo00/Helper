//
//  ViewModelType.swift
//  LSLPBasic
//
//  Created by youngjoo on 4/9/24.
//

import Foundation
import RxSwift

protocol ViewModelType {

    associatedtype Input
    associatedtype Output
    
    var disposeBag: DisposeBag { get set }
    
    func transform(input: Input) -> Output
}
