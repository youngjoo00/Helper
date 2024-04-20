//
//  WIrtePostView.swift
//  Helper
//
//  Created by youngjoo on 4/16/24.
//

import UIKit
import Then
import RxSwift
import RxCocoa

final class WritePostView: BaseView {
    
    lazy var hashTagSubject = BehaviorSubject<String>(value: hashtagButton.configuration?.title ?? "")
    lazy var categorySubject = BehaviorSubject<String>(value: categoryButton.configuration?.title ?? "")
    lazy var regionSubject = BehaviorSubject<String>(value: regionButton.configuration?.title ?? "")
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    let collectionView = BaseCollectionView(frame: .zero, collectionViewLayout: .writePostCollectionViewLayout()).then {
        $0.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: ImageCollectionViewCell.id)
        $0.showsHorizontalScrollIndicator = false
    }
    
    let buttonStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.spacing = 10
    }
    
    let hashtagButton = MenuButton(title: "찾고있어요").then { // 해시태그
        $0.showsMenuAsPrimaryAction = true // 버튼을 눌렀을 때 메뉴가 나오도록 설정
        $0.tag = 1
    }
    
    let categoryButton = MenuButton(title: "사람").then { // 사람/동물/물품 카테고리
        $0.showsMenuAsPrimaryAction = true
        $0.tag = 0
    }
    
    let titleLabel = PointLabel("제목", fontSize: 18)
    let titleTextField = PointTextField(placeholderText: "제목을 입력하세요")
    
    let featureLabel = PointLabel("특징", fontSize: 18)
    let featureTextField = PointTextField(placeholderText: "특징을 입력하세요")
    
    let regionLabel = PointLabel("지역", fontSize: 18)
    let regionButton = MenuButton(title: "서울특별시").then {
        $0.showsMenuAsPrimaryAction = true
        $0.tag = 2
    }

    let locateLabel = PointLabel("위치", fontSize: 18)
    let locateTextField = PointTextField(placeholderText: "상세 위치를 입력하세요")
    
    let dateLabel = PointLabel("날짜", fontSize: 18)
    let datePicker = UIDatePicker().then {
        $0.datePickerMode = .date
        $0.preferredDatePickerStyle = .compact
        $0.locale = Locale(identifier: "ko_KR")
    }
    
    let phoneLabel = PointLabel("연락처", fontSize: 18)
    let phoneTextField = PointTextField(placeholderText: "연락처를 입력하세요")
    
    let contentLabel = PointLabel("내용", fontSize: 18)
    let contentTextView = PointTextView()
    
    let bottomSpaceView = UIView()
    let completeButton = PointButton(title: "등록하기")
    
    override func configureHierarchy() {
        [
            scrollView,
            completeButton
        ].forEach { addSubview($0) }
        
        scrollView.addSubview(contentView)
        
        [
            collectionView,
            buttonStackView,
            titleLabel,
            titleTextField,
            featureLabel,
            featureTextField,
            regionLabel,
            regionButton,
            locateLabel,
            locateTextField,
            dateLabel,
            datePicker,
            phoneLabel,
            phoneTextField,
            contentLabel,
            contentTextView,
            bottomSpaceView
        ].forEach { contentView.addSubview($0) }

        
        [
            categoryButton,
            hashtagButton,
        ].forEach { buttonStackView.addArrangedSubview($0) }
    }
    
    override func configureLayout() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints { make in
            make.verticalEdges.equalTo(scrollView)
            make.width.equalTo(scrollView.snp.width)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalTo(safeAreaLayoutGuide)
            make.height.equalTo(150)
        }
        
        buttonStackView.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(16)
            make.height.equalTo(44)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(titleTextField)
            make.leading.equalTo(safeAreaLayoutGuide).offset(16)
            make.width.equalTo(60)
        }
        
        titleTextField.snp.makeConstraints { make in
            make.top.equalTo(buttonStackView.snp.bottom).offset(10)
            make.leading.equalTo(titleLabel.snp.trailing).offset(5)
            make.trailing.equalTo(safeAreaLayoutGuide).offset(-16)
            make.height.equalTo(44)
        }
        
        featureLabel.snp.makeConstraints { make in
            make.centerY.equalTo(featureTextField)
            make.leading.equalTo(titleLabel)
            make.width.equalTo(titleLabel)
        }
        
        featureTextField.snp.makeConstraints { make in
            make.top.equalTo(titleTextField.snp.bottom).offset(10)
            make.leading.equalTo(contentLabel.snp.trailing).offset(5)
            make.trailing.equalTo(safeAreaLayoutGuide).offset(-16)
            make.height.equalTo(44)
        }
        
        regionLabel.snp.makeConstraints { make in
            make.centerY.equalTo(regionButton)
            make.leading.equalTo(titleLabel)
            make.width.equalTo(titleLabel)
        }
        
        regionButton.snp.makeConstraints { make in
            make.top.equalTo(featureTextField.snp.bottom).offset(10)
            make.leading.equalTo(contentLabel.snp.trailing).offset(5)
            make.trailing.equalTo(safeAreaLayoutGuide).offset(-16)
            make.height.equalTo(44)
        }
        
        locateLabel.snp.makeConstraints { make in
            make.centerY.equalTo(locateTextField)
            make.leading.equalTo(titleLabel)
            make.width.equalTo(titleLabel)
        }
        
        locateTextField.snp.makeConstraints { make in
            make.top.equalTo(regionButton.snp.bottom).offset(10)
            make.leading.equalTo(contentLabel.snp.trailing).offset(5)
            make.trailing.equalTo(safeAreaLayoutGuide).offset(-16)
            make.height.equalTo(44)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.centerY.equalTo(datePicker)
            make.leading.equalTo(titleLabel)
            make.width.equalTo(titleLabel)
        }
        
        datePicker.snp.makeConstraints { make in
            make.top.equalTo(locateTextField.snp.bottom).offset(10)
            make.leading.equalTo(contentLabel.snp.trailing).offset(5)
            make.trailing.equalTo(safeAreaLayoutGuide).offset(-16)
            make.height.equalTo(44)
        }
        
        phoneLabel.snp.makeConstraints { make in
            make.centerY.equalTo(phoneTextField)
            make.leading.equalTo(titleLabel)
            make.width.equalTo(titleLabel)
        }
        
        phoneTextField.snp.makeConstraints { make in
            make.top.equalTo(datePicker.snp.bottom).offset(10)
            make.leading.equalTo(contentLabel.snp.trailing).offset(5)
            make.trailing.equalTo(safeAreaLayoutGuide).offset(-16)
            make.height.equalTo(44)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(contentTextView).offset(10)
            make.leading.equalTo(titleLabel)
            make.width.equalTo(titleLabel)
        }
        
        contentTextView.snp.makeConstraints { make in
            make.top.equalTo(phoneTextField.snp.bottom).offset(10)
            make.leading.equalTo(contentLabel.snp.trailing).offset(5)
            make.trailing.equalTo(safeAreaLayoutGuide).offset(-16)
            make.height.equalTo(150)
        }
        
        bottomSpaceView.snp.makeConstraints { make in
            make.top.equalTo(contentTextView.snp.bottom).offset(10)
            make.height.equalTo(100)
            make.horizontalEdges.bottom.equalToSuperview()
        }
        
        completeButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(44)
        }
    }
    
    override func configureView() {
        let hashtagActions = ["찾고있어요", "찾았어요"]
        configureMenu(hashtagButton, menuTitle: "상태를 선택하세요", actions: hashtagActions)
        
        let categoryActions = ["사람", "동물", "물품"]
        configureMenu(categoryButton, menuTitle: "카테고리를 선택하세요", actions: categoryActions)
        
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

// MARK: - Custom Func
extension WritePostView {
    private func configureMenu(_ button: UIButton, menuTitle: String, actions: [String]) {
        let actions = actions.map { title in
            UIAction(title: title) { [weak self] _ in
                guard let self else { return }
                button.configuration?.title = title
                switch button.tag {
                case 0:
                    self.categorySubject.onNext(title)
                case 1:
                    self.hashTagSubject.onNext(title)
                case 2:
                    self.regionSubject.onNext(title)
                default:
                    break
                }
            }
        }
        
        button.menu = UIMenu(title: menuTitle, children: actions)
    }
    
    func updateView(_ data: PostResponse.FetchPost) {
        updateButton(data.productId, hashTag: data.hashTags[0])
        titleTextField.text = data.title
        featureTextField.text = data.feature
        locateTextField.text = data.locate
        phoneTextField.text = data.phone
        contentTextView.text = data.content
        datePicker.date = DateManager.shared.formatStringToDate(data.date)
    }
    
    private func updateButton(_ productID: String, hashTag: String) {
        let splitProductID = productID.splitProductID
        hashtagButton.configuration?.title = hashTag
        regionButton.configuration?.title = splitProductID[0]
        categoryButton.configuration?.title = splitProductID[1]
        completeButton.configuration?.title = "수정하기"
        hashTagSubject.onNext(hashTag)
        regionSubject.onNext(splitProductID[0])
        categorySubject.onNext(splitProductID[1])
    }
}
