//
//  SettingTableViewCell.swift
//  Helper
//
//  Created by youngjoo on 4/16/24.
//

import UIKit
import Then

final class SettingTableViewCell: BaseTableViewCell {
    
    private let titleLabel = PointBoldLabel("test", fontSize: 17)
    
    override func configureHierarchy() {
        [
            titleLabel,
        ].forEach { contentView.addSubview($0) }
    }
    
    override func configureLayout() {
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(16)
        }
    }
    
    override func configureView() {
        selectionStyle = .none
    }
}


extension SettingTableViewCell {
    
    func updateView(_ title: String) {
        titleLabel.text = title
        print(title)
    }

}
