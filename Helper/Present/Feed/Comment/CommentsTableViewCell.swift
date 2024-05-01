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
    
    lazy var profileStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 10
        $0.alignment = .top
        $0.addGestureRecognizer(profileTabGesture)
    }
    let profileTabGesture = UITapGestureRecognizer()
    let profileImageView = ProfileImageView()
    let nicknameLabel = PointBoldLabel(fontSize: 18)

    private let regDateLabel = PointLabel("20시간 전", fontSize: 15)
    private let editButton = ImageButton(image: UIImage(systemName: "ellipsis.circle")).then {
        $0.showsMenuAsPrimaryAction = true
    }
    private let commentLabel = PointLabel("머시기저시기", fontSize: 15).then {
        $0.numberOfLines = 0
    }

    override func configureHierarchy() {
        [
            profileStackView,
            regDateLabel,
            commentLabel,
            editButton
        ].forEach { contentView.addSubview($0) }
        
        [
            profileImageView,
            nicknameLabel,
        ].forEach { profileStackView.addArrangedSubview($0) }
    }
    
    override func configureLayout() {
        
        profileStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.leading.equalTo(safeAreaLayoutGuide).inset(16)
            make.height.equalTo(33)
        }
        
        profileImageView.snp.makeConstraints { make in
            make.top.equalTo(nicknameLabel)
            make.size.equalTo(33)
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
            UIAction(title: "삭제", image: UIImage(systemName: "trash"), attributes: .destructive) { [weak self] _ in
                guard let self else { return }
                self.deleteSubject.onNext(commentID)
            }
        }
        
        button.menu = UIMenu(title: menuTitle, children: actions)
    }
}
