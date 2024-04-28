//
//  SettingView.swift
//  Helper
//
//  Created by youngjoo on 4/16/24.
//

import UIKit
import Then

final class SettingView: BaseView {
    
    let tableView = UITableView().then {
        $0.register(SettingTableViewCell.self, forCellReuseIdentifier: SettingTableViewCell.id)
        $0.backgroundColor = .clear
        $0.separatorStyle = .none
        $0.rowHeight = 44
    }
    
    override func configureHierarchy() {
        [
            tableView
        ].forEach { addSubview($0) }
    }
    
    override func configureLayout() {
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }
    }
    
    override func configureView() {
        
    }
}
