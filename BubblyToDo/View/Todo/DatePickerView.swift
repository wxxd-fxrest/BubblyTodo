//
//  DatePickerView.swift
//  BubblyToDo
//
//  Created by 밀가루 on 9/28/24.
//

//import UIKit
//import SnapKit
//
//class DatePickerView: UIView {
//    private var viewModel: DatePickerViewModel
//
//    lazy var modalView = UIFactory.makeView(backgroundColor: MySpecialColors.WhiteColor, cornerRadius: 12)
//    var closeButton = UIFactory.makeSystemImageButton(image: "xmark", tintColor: MySpecialColors.MainColor)
//
//    private lazy var layout: UICollectionViewFlowLayout = {
//        let layout = UICollectionViewFlowLayout()
//        layout.scrollDirection = .vertical
//        return layout
//    }()
//    
//    lazy var datePickerCollection: UICollectionView = {
//        return UIFactory.makeCollectionView(layout: layout, scrollDirection: .vertical)
//    }()
//
//    let leftArrowImage = UIFactory.makeImageButton(image: "leftArrow", tintColor: MySpecialColors.MainColor)
//    let rightArrowImage = UIFactory.makeImageButton(image: "rightArrow", tintColor: MySpecialColors.MainColor)
//
//    init(viewModel: DatePickerViewModel) {
//        self.viewModel = viewModel
//        super.init(frame: .zero)
//        setupSubviews()
//        reloadData()
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    private func setupSubviews() {
//        addSubview(modalView)
//        modalView.addSubviews(leftArrowImage, rightArrowImage, closeButton, datePickerCollection)
//        
//        closeButton.addTarget(self, action: #selector(closeModal), for: .touchUpInside)
//        
//        // 컬렉션 뷰의 콘텐츠 인셋 설정
//        datePickerCollection.contentInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
//        datePickerCollection.scrollIndicatorInsets = datePickerCollection.contentInset
//        
//        // 모달 뷰 제약 조건
//        modalView.snp.makeConstraints {
//            $0.center.equalToSuperview()
//            $0.leading.trailing.equalToSuperview().inset(24)
//            $0.height.equalTo(400)
//        }
//        
//        // 닫기 버튼 제약 조건
//        closeButton.snp.makeConstraints {
//            $0.top.trailing.equalTo(modalView).inset(10)
//        }
//        
//        // 화살표 버튼 제약 조건
//        leftArrowImage.snp.makeConstraints {
//            $0.top.equalTo(modalView).offset(20)
//            $0.leading.equalTo(modalView).offset(20)
//        }
//        
//        rightArrowImage.snp.makeConstraints {
//            $0.top.equalTo(modalView).offset(20)
//            $0.trailing.equalTo(modalView).offset(-20)
//        }
//        
//        // 컬렉션 뷰 제약 조건
//        datePickerCollection.snp.makeConstraints {
//            $0.top.equalTo(leftArrowImage.snp.bottom).offset(20)
//            $0.leading.trailing.bottom.equalTo(modalView).inset(24)
//        }
//        
//        datePickerCollection.dataSource = self
//        datePickerCollection.delegate = self
//        datePickerCollection.register(DateCell.self, forCellWithReuseIdentifier: "DateCell")
//    }
//    
//    @objc private func closeModal() {
//        self.removeFromSuperview()
//    }
//    
//    func reloadData() {
//        datePickerCollection.reloadData()
//    }
//}
//
//extension DatePickerView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return viewModel.dateModel.dates.count / 7 + (viewModel.dateModel.dates.count % 7 > 0 ? 1 : 0)
//    }
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return 7
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DateCell", for: indexPath) as! DateCell
//        let index = indexPath.section * 7 + indexPath.item
//        
//        if index < viewModel.dateModel.dates.count {
//            let dateString = viewModel.dateModel.dates[index]
//            cell.weekDateText.text = dateString
//            cell.weekDateText.isHidden = dateString.isEmpty
//            
//            if let day = Int(dateString), day == Calendar.current.component(.day, from: viewModel.dateModel.selectedDate) {
//                cell.weekDateView.backgroundColor = MySpecialColors.MainColor
//                cell.weekDateText.textColor = MySpecialColors.WhiteColor
//            } else {
//                cell.weekDateView.backgroundColor = MySpecialColors.DateBackColor
//                cell.weekDateText.textColor = MySpecialColors.TextColor
//            }
//        } else {
//            cell.weekDateText.isHidden = true
//            cell.weekDateView.backgroundColor = .clear
//        }
//        
//        return cell
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let totalWidth = collectionView.frame.width - 48 // 양쪽 여백 24px * 2
//        let spacing = 12 * 6 // 7개의 아이템 사이에 6개의 간격
//        let width = (Int(totalWidth) - spacing) / 7 // 총 너비에서 간격을 빼고 7로 나누기
//        return CGSize(width: width, height: width) // 너비와 높이를 동일하게 설정
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return 12 // 아이템 간의 수직 간격
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 16 // 줄 간의 수평 간격
//    }
//}


//import UIKit
//import SnapKit
//
//class DatePickerViewController: UIViewController {
//    private var viewModel: DatePickerViewModel
//
//    lazy var modalView = UIFactory.makeView(backgroundColor: MySpecialColors.WhiteColor, cornerRadius: 12)
//    
//    init(viewModel: DatePickerViewModel) {
//        self.viewModel = viewModel
//        super.init(nibName: nil, bundle: nil)
//        
//        setupSubviews()
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    private func setupSubviews() {
//        view.addSubview(modalView)
//
//        modalView.snp.makeConstraints {
//            $0.leading.trailing.equalToSuperview().inset(24)
//            $0.height.equalTo(400)
//            $0.top.equalToSuperview().offset(0) // 디폴트 위치
//        }
//    }
//}
//
