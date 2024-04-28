//
//  CommentsTableViewCell.swift
//  Helper
//
//  Created by youngjoo on 4/18/24.
//

import UIKit
import Then
import RxSwift
import RxCocoa

final class CommentsTableViewCell: BaseTableViewCell {
    
    lazy var deleteSubject = PublishSubject<String>()
    
    private var commentID = ""
    
    private let profileImageView = ProfileImageView()
    private let nicknameLabel = PointBoldLabel("닉네임", fontSize: 18)
    private let regDateLabel = PointLabel("20시간 전", fontSize: 15)
    private let editButton = ImageButton(image: UIImage(systemName: "ellipsis.circle")).then {
        $0.showsMenuAsPrimaryAction = true
    }
    private let commentLabel = PointLabel("머시기저시기", fontSize: 15).then {
        $0.numberOfLines = 0
    }

    override func configureHierarchy() {
        [
            profileImageView,
            nicknameLabel,
            regDateLabel,
            commentLabel,
            editButton
        ].forEach { contentView.addSubview($0) }
    }
    
    override func configureLayout() {
        
        profileImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.leading.equalTo(safeAreaLayoutGuide).offset(16)
            make.size.equalTo(33)
        }
        
        nicknameLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView)
            make.leading.equalTo(profileImageView.snp.trailing).offset(10)
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
            make.top.equalTo(nicknameLabel.snp.bottom).offset(5)
            make.leading.equalTo(nicknameLabel)
            make.trailing.equalTo(safeAreaLayoutGuide).inset(16)
            make.bottom.equalToSuperview().offset(-10)
        }
    }
    
    override func configureView() {
        let editList = [
            "삭제",
        ]
        
        configureMenu(editButton, menuTitle: "", actions: editList)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        disposeBag = DisposeBag()
    }
}


// MARK: - Custom Func
extension CommentsTableViewCell {
    
    func updateView(_ data: Comments) {
        commentID = data.commentID
        profileImageView.loadImage(urlString: data.creator.profileImage)
        nicknameLabel.text = data.creator.nick
        regDateLabel.text = DateManager.shared.dateFormat(data.createdAt)
        commentLabel.text = data.content
        editButton.isHidden = !data.creator.userID.checkedUserID
    }
    
    private func configureMenu(_ button: UIButton, menuTitle: String, actions: [String]) {
        let actions = actions.map { title in
            UIAction(title: title) { [weak self] _ in
                guard let self else { return }
                self.deleteSubject.onNext(commentID)
            }
        }
        
        button.menu = UIMenu(title: menuTitle, children: actions)
    }
}
