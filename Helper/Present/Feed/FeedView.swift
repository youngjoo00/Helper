//
//  FeedView.swift
//  Helper
//
//  Created by youngjoo on 4/28/24.
//

import UIKit
import Then

final class FeedView: BaseView {
    
    let refreshControl = UIRefreshControl()
    
    let activityIndicator = UIActivityIndicatorView(style: .medium).then {
        $0.hidesWhenStopped = true
    }
    
    lazy var tableView = BaseTableView().then {
        $0.register(FeedTableViewCell.self, forCellReuseIdentifier: FeedTableViewCell.id)
        $0.refreshControl = refreshControl
        $0.rowHeight = UITableView.automaticDimension
        $0.estimatedRowHeight = 44
        $0.separatorStyle = .none
        $0.showsVerticalScrollIndicator = false
    }
    
    override func configureHierarchy() {
        [
            tableView,
            activityIndicator
        ].forEach { addSubview($0) }
    }
    
    override func configureLayout() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        activityIndicator.snp.makeConstraints { make in
            make.bottom.equalTo(safeAreaLayoutGuide).offset(-10)
            make.centerX.equalToSuperview()
        }
    }
    
    override func configureView() {
        
    }
}
