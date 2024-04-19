//
//  CommentsTableViewCell.swift
//  Helper
//
//  Created by youngjoo on 4/18/24.
//

import UIKit
import Then

final class CommentsTableViewCell: BaseTableViewCell {
    
    private let nicknameLabel = PointBoldLabel("닉네임", fontSize: 18)
    private let regDateLabel = PointLabel("20시간 전", fontSize: 15)
    private let editButton = ImageButton(image: UIImage(systemName: "ellipsis.circle"))
    private let commentLabel = PointLabel("머시기저시기", fontSize: 15).then {
        $0.numberOfLines = 0
    }

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
            make.size.equalTo(20)
        }
        
        commentLabel.snp.makeConstraints { make in
            make.top.equalTo(nicknameLabel.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(16)
            make.bottom.equalToSuperview().offset(-5)
        }
    }
    
    override func configureView() {
        
    }
}


// MARK: - Custom Func
extension CommentsTableViewCell {
    
    func updateView(_ data: Comments) {
        nicknameLabel.text = data.creator.nick
        regDateLabel.text = DateManager.shared.dateFormat(data.createdAt)
        commentLabel.text = data.content
    }
}
