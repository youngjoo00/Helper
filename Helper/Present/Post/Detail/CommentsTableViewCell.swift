//
//  CommentsTableViewCell.swift
//  Helper
//
//  Created by youngjoo on 4/18/24.
//

import UIKit
import Then

final class CommentsTableViewCell: BaseTableViewCell {
    
    let nicknameLabel = PointBoldLabel("닉네임", fontSize: 18)
    let regDateLabel = PointLabel("20시간 전", fontSize: 15)
    let editButton = PointButton(title: nil, image: UIImage(systemName: "ellipsis.circle"))
    let commentLabel = PointLabel("머시기저시기", fontSize: 15)

    override func configureHierarchy() {
        [
            nicknameLabel,
            regDateLabel,
            commentLabel,
            editButton
        ].forEach { contentView.addSubview($0) }
    }
    
    override func configureLayout() {
        nicknameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(5)
            make.leading.equalTo(safeAreaLayoutGuide).offset(16)
        }
        
        regDateLabel.snp.makeConstraints { make in
            make.centerY.equalTo(nicknameLabel)
            make.leading.equalTo(nicknameLabel.snp.trailing).offset(10)
        }
        
        editButton.snp.makeConstraints { make in
            make.top.equalTo(nicknameLabel)
            make.trailing.equalTo(safeAreaLayoutGuide).offset(-16)
            make.size.equalTo(30)
        }
        
        commentLabel.snp.makeConstraints { make in
            make.top.equalTo(nicknameLabel.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(16)
        }
    }
    
    override func configureView() {
        
    }
}
