//
//  WriteFeedView.swift
//  Helper
//
//  Created by youngjoo on 4/28/24.
//

import UIKit
import Then
import RxSwift
import RxCocoa

final class WriteFeedView: BaseView {
    
    let collectionView = BaseCollectionView(frame: .zero, collectionViewLayout: .writePostCollectionViewLayout()).then {
        $0.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: ImageCollectionViewCell.id)
        $0.showsHorizontalScrollIndicator = false
    }
    
    let titleLabel = PointLabel("내용*", fontSize: 18)
    let titleTextView = PointTextView()
    
    let completeButton = PointButton(title: "등록하기")
    override func configureHierarchy() {
        [
            collectionView,
            titleLabel,
            titleTextView,
            completeButton
        ].forEach { addSubview($0) }
    }
    
    override func configureLayout() {
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(10)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide)
            make.height.equalTo(150)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.bottom).offset(20)
            make.leading.equalTo(safeAreaLayoutGuide).offset(16)
            make.width.equalTo(60)
        }
        
        titleTextView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(16)
            make.height.equalTo(150)
        }
        
        completeButton.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(16)
            make.height.equalTo(44)
        }
        
    }
    
    override func configureView() {
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if safeAreaInsets.bottom == 0 {
            completeButton.snp.makeConstraints { make in
                make.bottom.equalTo(safeAreaInsets).offset(-16)
            }
        } else {
            completeButton.snp.makeConstraints { make in
                make.bottom.equalTo(safeAreaLayoutGuide)
            }
        }
    }
}

extension WriteFeedView {
    
    func updateView(_ postInfo: PostResponse.FetchPost) {        
        titleTextView.text = postInfo.title
        completeButton.configuration?.title = "수정하기"
    }
}
