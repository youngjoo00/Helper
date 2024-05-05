//
//  EditProfileTableViewCell.swift
//  Helper
//
//  Created by youngjoo on 4/24/24.
//

import Foundation

final class EditProfileTableViewCell: BaseTableViewCell {
    
    let contentlabel = PointLabel(fontSize: 17)
    let contentValueLabel = PointLabel(fontSize: 17)

    override func configureHierarchy() {
        [
            contentlabel,
            contentValueLabel
        ].forEach { contentView.addSubview($0) }
    }
    
    override func configureLayout() {
        contentlabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(safeAreaLayoutGuide).offset(16)
            make.width.equalTo(80)
        }
        
        contentValueLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(contentlabel.snp.trailing)
            make.trailing.equalTo(safeAreaLayoutGuide).offset(-16)
        }
    }
    
    override func configureView() {
        
    }
}


// MARK: - Custom Func
extension EditProfileTableViewCell {
    
    func updateView(content: String, contentValue: String) {
        contentlabel.text = content
        contentValueLabel.text = contentValue
        
        if content == EditProfileList.nick.title || content == EditProfileList.phone.title {
            self.accessoryType = .disclosureIndicator
        } else {
            self.accessoryType = .none
        }
        
    }
}
