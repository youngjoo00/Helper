//
//  CommentView.swift
//  Helper
//
//  Created by youngjoo on 4/28/24.
//

import UIKit
import Then
import RxSwift
import SnapKit

final class CommentView: BaseView {
    
    lazy var commentWriteSubject = BehaviorSubject<String>(value: commentWriteTextView.text ?? "")
    
    let titleLabel = PointBoldLabel(fontSize: 18)
    
    let activityIndicator = UIActivityIndicatorView(style: .medium).then {
        $0.hidesWhenStopped = true
    }
    
    let commentsTableView = BaseTableView().then {
        $0.register(CommentsTableViewCell.self, forCellReuseIdentifier: CommentsTableViewCell.id)
        $0.estimatedRowHeight = 44
        $0.rowHeight = UITableView.automaticDimension
        $0.separatorStyle = .none
    }
    
    let commentView = UIView().then {
        $0.backgroundColor = .white
    }
    let commentWriteTextView = CommentTextView()
    let commentWriteButton = PointButton(title: "등록")
    
    var bottomConstraint: Constraint?
    
    override func configureHierarchy() {
        [
            titleLabel,
            commentsTableView,
            activityIndicator,
            commentView
        ].forEach { addSubview($0) }
        
        [
            commentWriteTextView,
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
            // 변수에 constraint 타입의 값을 담아놓고 업데이트를 하는 방식이 가능하다,,
            bottomConstraint = make.bottom.equalTo(safeAreaLayoutGuide).constraint
            make.horizontalEdges.equalTo(safeAreaLayoutGuide)
            make.height.equalTo(commentWriteTextView).offset(20)
        }
        
        commentWriteTextView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.height.equalTo(44)
            make.leading.equalTo(safeAreaLayoutGuide).offset(16)
            make.trailing.equalTo(commentWriteButton.snp.leading).offset(-16)
        }
        
        commentWriteButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-10)
            make.height.equalTo(44)
            make.width.equalTo(70)
            make.trailing.equalTo(safeAreaLayoutGuide).offset(-16)
        }
    }
    
    override func configureView() {
    }
}

extension CommentView {
    
    func updateCommentTextView() {
        commentWriteTextView.text = ""
        commentWriteSubject.onNext("")
    }
    
    func adjustTextViewHeight() {
        let maxHeight: CGFloat = 100.0
        
        // sizeThatFits를 사용하여 실제 필요한 높이 계산
        let fittingSize = commentWriteTextView.sizeThatFits(CGSize(width: commentWriteTextView.bounds.width, height: CGFloat.infinity))
        let currentHeight = max(44.0, fittingSize.height)
        
        if currentHeight <= maxHeight {
            // 최대 높이 이하일 경우
            commentWriteTextView.snp.updateConstraints { make in
                make.height.equalTo(currentHeight)
            }
            commentWriteTextView.isScrollEnabled = false // 스크롤 비활성화
        } else {
            // 최대 높이를 초과할 경우
            commentWriteTextView.snp.updateConstraints { make in
                make.height.equalTo(maxHeight)
            }
            commentWriteTextView.isScrollEnabled = true // 스크롤 활성화
        }
        
        commentWriteTextView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        
        // 레이아웃 업데이트
        self.layoutIfNeeded()
    }
}
