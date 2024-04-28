//
//  CommentView.swift
//  Helper
//
//  Created by youngjoo on 4/28/24.
//

import UIKit
import Then
import RxSwift

final class CommentView: BaseView {
    
    lazy var commentWriteSubject = BehaviorSubject<String>(value: commentWriteTextField.text ?? "")
    
    let titleLabel = PointBoldLabel(fontSize: 18)
    
    let activityIndicator = UIActivityIndicatorView(style: .medium).then {
        $0.hidesWhenStopped = true
    }
    
    let commentsTableView = BaseTableView().then {
        $0.register(CommentsTableViewCell.self, forCellReuseIdentifier: CommentsTableViewCell.id)
        $0.estimatedRowHeight = 44
        $0.rowHeight = UITableView.automaticDimension
    }
    
    let commentView = UIView().then {
        $0.backgroundColor = .white
    }
    let commentWriteTextField = PointTextField(placeholderText: "댓글 내용을 입력하세요")
    let commentWriteButton = PointButton(title: "등록")
    
    override func configureHierarchy() {
        [
            titleLabel,
            commentsTableView,
            activityIndicator,
            commentView
        ].forEach { addSubview($0) }
        
        [
            commentWriteTextField,
            commentWriteButton,
        ].forEach { commentView.addSubview($0) }
    }
    
    override func configureLayout() {
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
        }
        
        commentsTableView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(commentView.snp.top)
        }
        
        activityIndicator.snp.makeConstraints { make in
            make.bottom.equalTo(commentsTableView.snp.bottom).offset(-10)
            make.centerX.equalToSuperview()
        }
        
        commentView.snp.makeConstraints { make in
            make.bottom.horizontalEdges.equalTo(safeAreaLayoutGuide)
            make.height.equalTo(66)
        }
        
        commentWriteTextField.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.height.equalTo(44)
            make.leading.equalTo(safeAreaLayoutGuide).offset(16)
            make.trailing.equalTo(commentWriteButton.snp.leading).offset(-16)
        }
        
        commentWriteButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.height.equalTo(44)
            make.width.equalTo(70)
            make.trailing.equalTo(safeAreaLayoutGuide).offset(-16)
        }
    }
    
    override func configureView() {
        
    }
}

extension CommentView {
    
    func updateCommentTextField() {
        commentWriteTextField.text = ""
        commentWriteSubject.onNext("")
    }
    
}
