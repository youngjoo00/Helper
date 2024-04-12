//
//  ViewModelType.swift
//  LSLPBasic
//
//  Created by youngjoo on 4/9/24.
//

import Foundation
import RxSwift

// 프로토콜에서 제네릭은 못씀 <T> : An associated type named 'T' must be declared in the protocol 'ViewModelType' or a protocol it inherits
protocol ViewModelType {

    // 대신에 associatedtype 을 통해 구조화함
    associatedtype Input
    associatedtype Output
    
//    associatedtype Jack: Numeric
//    func sum(a: Jack, b: Jack) -> Jack
    
    // 프로토콜은 구조체를 정의할 수 없음
//    struct Input {
//        
//    }
//    
//    struct Output {
//        <#fields#>
//    }
    var disposeBag: DisposeBag { get set }
    
    func transform(input: Input) -> Output
}
