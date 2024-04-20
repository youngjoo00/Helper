//
//  PostView.swift
//  Helper
//
//  Created by youngjoo on 4/13/24.
//

import UIKit
import Then
import RxSwift
import RxCocoa

final class FindingView: BaseView {

    lazy var regionSubject = BehaviorSubject(value: regionButton.configuration?.title ?? "")
    
    let categorySegmentControl = UISegmentedControl().then {
        $0.insertSegment(withTitle: "사람", at: 0, animated: false)
        $0.insertSegment(withTitle: "애완동물", at: 1, animated: false)
        $0.insertSegment(withTitle: "물품", at: 2, animated: false)
        $0.selectedSegmentIndex = 0
        $0.setTitleTextAttributes([.foregroundColor: UIColor.black], for: .selected)
        $0.setTitleTextAttributes([.foregroundColor: UIColor.lightGray], for: .normal)
        $0.apportionsSegmentWidthsByContent = true
    }
    
    let regionButton = MenuButton(title: "서울특별시").then {
        $0.showsMenuAsPrimaryAction = true
    }
    
    let collectionView = BaseCollectionView(frame: .zero, collectionViewLayout: .postCollectionViewLayout()).then {
        $0.register(PostCollectionViewCell.self, forCellWithReuseIdentifier: PostCollectionViewCell.id)
    }
    
    override func configureHierarchy() {
        [
            categorySegmentControl,
            regionButton,
            collectionView
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
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(categorySegmentControl.snp.bottom).offset(10)
            make.horizontalEdges.bottom.equalTo(safeAreaLayoutGuide)
        }
    }
    
    override func configureView() {
        let regionActions = [
            "서울특별시",
            "부산광역시",
            "대구광역시",
            "인천광역시",
            "광주광역시",
            "대전광역시",
            "울산광역시",
            "세종특별자치시",
            "경기도",
            "강원도",
            "충청북도",
            "충청남도",
            "전라북도",
            "전라남도",
            "경상북도",
            "경상남도",
            "제주특별자치도"
        ]
        configureMenu(regionButton, menuTitle: "지역을 선택하세요", actions: regionActions)
    }
}

extension FindingView {
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
