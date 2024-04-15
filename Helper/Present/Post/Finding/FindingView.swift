//
//  PostView.swift
//  Helper
//
//  Created by youngjoo on 4/13/24.
//

import UIKit
import Then

final class FindingView: BaseView {

    let categorySegmentControl = UISegmentedControl().then {
        $0.insertSegment(withTitle: "사람", at: 0, animated: false)
        $0.insertSegment(withTitle: "애완동물", at: 1, animated: false)
        $0.insertSegment(withTitle: "물품", at: 2, animated: false)
        $0.selectedSegmentIndex = 0
        $0.setTitleTextAttributes([.foregroundColor: UIColor.black], for: .selected)
        $0.setTitleTextAttributes([.foregroundColor: UIColor.lightGray], for: .normal)
        $0.apportionsSegmentWidthsByContent = true
    }
    
    let regionsButton = PointButton(title: "서울특별시")
    
    override func configureHierarchy() {
        [
            categorySegmentControl,
            regionsButton,
        ].forEach { addSubview($0) }
    }
    
    override func configureLayout() {
        categorySegmentControl.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(10)
            make.leading.equalTo(safeAreaLayoutGuide).offset(16)
            make.width.equalTo(200)
            make.height.equalTo(44)
        }
        
        regionsButton.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(10)
            make.trailing.equalTo(safeAreaLayoutGuide).offset(-16)
            make.height.equalTo(44)
        }
    }
}
