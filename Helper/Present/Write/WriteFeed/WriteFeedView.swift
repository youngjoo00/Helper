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
    
    let hashTagLabel = PointLabel("해시태그", fontSize: 18)
    let hashTagTextField = PointTextField(placeholderText: "#해시태그를 작성해보세요")
    
    let completeButton = PointButton(title: "등록하기")
    override func configureHierarchy() {
        [
            collectionView,
            titleLabel,
            titleTextView,
            hashTagLabel,
            hashTagTextField,
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
        
        hashTagLabel.snp.makeConstraints { make in
            make.top.equalTo(titleTextView.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(16)
        }
        
        hashTagTextField.snp.makeConstraints { make in
            make.top.equalTo(hashTagLabel.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(16)
            make.height.equalTo(44)
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
