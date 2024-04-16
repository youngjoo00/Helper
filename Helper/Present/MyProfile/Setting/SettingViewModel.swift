//
//  SettingViewModel.swift
//  Helper
//
//  Created by youngjoo on 4/16/24.
//

import Foundation
import RxSwift
import RxCocoa

final class SettingViewModel: ViewModelType {
    
    var disposeBag: RxSwift.DisposeBag = .init()
    
    struct Input {
        let viewDidLoadTrigger: Observable<Void>
    }
    
    struct Output {
        let content: Driver<[String]>
    }
    
    func transform(input: Input) -> Output {
        
        let content: BehaviorRelay<[String]> = BehaviorRelay(value: [])
        
        input.viewDidLoadTrigger
            .map { Setting.allCases[0].sectionContent }
            .subscribe(with: self) { owner, data in
                content.accept(data)
            }
            .disposed(by: disposeBag)
        
        return Output(content: content.asDriver(onErrorJustReturn: []))
    }
}

extension SettingViewModel {
    enum Setting: Int, CaseIterable {
        case user
        
        var sectionTitle: String {
            switch self {
            case .user:
                return "계정"
            }
        }
        
        var sectionContent: [String] {
            switch self {
            case .user:
                return ["로그아웃", "회원탈퇴"]
            }
        }
    }
}


