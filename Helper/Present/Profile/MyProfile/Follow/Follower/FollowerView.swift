//
//  FollowerView.swift
//  Helper
//
//  Created by youngjoo on 4/27/24.
//

import UIKit
import Then

final class FollowerView: BaseView {
    
    let searchBar = UISearchBar().then {
        $0.searchBarStyle = .minimal
        $0.placeholder = "닉네임을 검색해보세요"
    }
    
    let followerTableView = BaseTableView().then {
        $0.register(FollowerTableViewCell.self, forCellReuseIdentifier: FollowerTableViewCell.id)
        $0.separatorStyle = .none
        $0.rowHeight = 70
    }
    
    override func configureHierarchy() {
        [
            searchBar,
            followerTableView
        ].forEach { addSubview($0) }
    }
    
    override func configureLayout() {
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(5)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(44)
        }
        
        followerTableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(5)
            make.horizontalEdges.bottom.equalToSuperview()
        }
    }
    
    override func configureView() {
        
    }
}
