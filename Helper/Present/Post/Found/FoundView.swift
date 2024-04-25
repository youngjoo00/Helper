//
//  FoundView.swift
//  Helper
//
//  Created by youngjoo on 4/13/24.
//

import UIKit
import Then
import RxSwift
import RxCocoa

final class FoundView: BaseView {

    lazy var regionSubject = BehaviorSubject(value: regionButton.configuration?.title ?? "")
    
    let refreshControl = UIRefreshControl()
    
    let categorySegmentControl = UISegmentedControl().then {
        $0.insertSegment(withTitle: HelperString.categoryPerson, at: 0, animated: false)
        $0.insertSegment(withTitle: HelperString.categoryAnimal, at: 1, animated: false)
        $0.insertSegment(withTitle: HelperString.categoryThing, at: 2, animated: false)
        $0.selectedSegmentIndex = 0
        $0.setTitleTextAttributes([.foregroundColor: UIColor.black], for: .selected)
        $0.setTitleTextAttributes([.foregroundColor: UIColor.lightGray], for: .normal)
        $0.apportionsSegmentWidthsByContent = true
    }
    
    let regionButton = MenuButton(title: HelperString.regions[0]).then {
        $0.showsMenuAsPrimaryAction = true
    }
    
    let postsView = PostsView()
    
    override func configureHierarchy() {
        [
            categorySegmentControl,
            regionButton,
            postsView
        ].forEach { addSubview($0) }
    }
    
    override func configureLayout() {
        categorySegmentControl.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(10)
            make.leading.equalTo(safeAreaLayoutGuide).offset(16)
            make.width.equalTo(200)
            make.height.equalTo(44)
        }
        
        regionButton.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(10)
            make.trailing.equalTo(safeAreaLayoutGuide).offset(-16)
            make.height.equalTo(44)
        }
        
        postsView.snp.makeConstraints { make in
            make.top.equalTo(categorySegmentControl.snp.bottom).offset(10)
            make.horizontalEdges.bottom.equalTo(safeAreaLayoutGuide)
        }
    }
    
    override func configureView() {
        configureMenu(regionButton, menuTitle: "지역을 선택하세요", actions: HelperString.regions)
    }
}

extension FoundView {
    private func configureMenu(_ button: UIButton, menuTitle: String, actions: [String]) {
        let actions = actions.map { title in
            UIAction(title: title) { [weak self] _ in
                guard let self else { return }
                button.configuration?.title = title
                self.regionSubject.onNext(title)
            }
        }
        
        button.menu = UIMenu(title: menuTitle, children: actions)
    }
}
