//
//  DatePickerViewController.swift
//  BubblyToDo
//
//  Created by 밀가루 on 9/28/24.
//

import UIKit
import SnapKit

class DatePickerView: UIView {
    let weekDays = ["일", "월", "화", "수", "목", "금", "토"]
    private var dates: [String] = []
    private var selectedDate: Date
    private var currentYear: Int
    private var currentMonth: Int
    
    private lazy var modalView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 12
        view.layer.masksToBounds = true
        return view
    }()
    
    private lazy var closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("✖️", for: .normal)
        button.addTarget(self, action: #selector(closeModal), for: .touchUpInside)
        return button
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()
    
    lazy var leftArrowButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("<", for: .normal)
        button.addTarget(self, action: #selector(previousMonth), for: .touchUpInside)
        return button
    }()
    
    lazy var rightArrowButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(">", for: .normal)
        button.addTarget(self, action: #selector(nextMonth), for: .touchUpInside)
        return button
    }()
    
    init(selectedDate: Date) {
        self.selectedDate = selectedDate
        let calendar = Calendar.current
        self.currentYear = calendar.component(.year, from: selectedDate)
        self.currentMonth = calendar.component(.month, from: selectedDate)
        super.init(frame: .zero)
        
        setupSubviews()
        loadDates(for: currentYear, month: currentMonth)
        
        // 배경 클릭 제스처 추가
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(closeModal))
        self.addGestureRecognizer(tapGesture)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        addSubview(modalView)
        modalView.addSubview(leftArrowButton)
        modalView.addSubview(rightArrowButton)
        modalView.addSubview(closeButton)
        modalView.addSubview(collectionView)
        
        // 모달 뷰 제약 조건
        modalView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(300) // 원하는 너비
            $0.height.equalTo(400) // 원하는 높이
        }
        
        // 닫기 버튼 제약 조건
        closeButton.snp.makeConstraints {
            $0.top.trailing.equalTo(modalView).inset(10)
        }
        
        // 화살표 버튼 제약 조건
        leftArrowButton.snp.makeConstraints {
            $0.top.equalTo(modalView).offset(20)
            $0.leading.equalTo(modalView).offset(20)
        }
        
        rightArrowButton.snp.makeConstraints {
            $0.top.equalTo(modalView).offset(20)
            $0.trailing.equalTo(modalView).offset(-20)
        }
        
        // 컬렉션 뷰 제약 조건
        collectionView.snp.makeConstraints {
            $0.top.equalTo(leftArrowButton.snp.bottom).offset(20)
            $0.leading.trailing.bottom.equalTo(modalView)
        }
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(DateCell.self, forCellWithReuseIdentifier: "DateCell")
    }
    
    private func loadDates(for year: Int, month: Int) {
        dates = datesForMonth(year: year, month: month)
        collectionView.reloadData()
    }
    
    private func datesForMonth(year: Int, month: Int) -> [String] {
        var dates: [String] = []
        let calendar = Calendar.current
        var dateComponents = DateComponents(year: year, month: month)
        
        guard let firstDate = calendar.date(from: dateComponents) else { return [] }
        
        let range = calendar.range(of: .day, in: .month, for: firstDate)!
        let firstWeekday = calendar.component(.weekday, from: firstDate) // 1(일) ~ 7(토)
        
        for _ in 1..<firstWeekday {
            dates.append("") // 빈 문자열 추가
        }
        
        for day in 1...range.count {
            dates.append("\(day)")
        }
        
        return dates
    }
    
    @objc private func previousMonth() {
        if currentMonth == 1 {
            currentMonth = 12
            currentYear -= 1
        } else {
            currentMonth -= 1
        }
        loadDates(for: currentYear, month: currentMonth)
    }
    
    @objc private func nextMonth() {
        if currentMonth == 12 {
            currentMonth = 1
            currentYear += 1
        } else {
            currentMonth += 1
        }
        loadDates(for: currentYear, month: currentMonth)
    }
    
    @objc private func closeModal() {
        self.removeFromSuperview()
    }
}

// MARK: UICollectionViewDataSource, UICollectionViewDelegate
extension DatePickerView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dates.count / 7 + (dates.count % 7 > 0 ? 1 : 0)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DateCell", for: indexPath) as! DateCell
        let index = indexPath.section * 7 + indexPath.item
        
        if index < dates.count {
            let dateString = dates[index]
            cell.weekDateText.text = dateString
            cell.weekDateText.isHidden = dateString.isEmpty
            
            // 선택된 날짜를 강조
            if let day = Int(dateString), day == Calendar.current.component(.day, from: selectedDate) {
                cell.weekDateView.backgroundColor = MySpecialColors.MainColor
                cell.weekDateText.textColor = MySpecialColors.WhiteColor
            } else {
                cell.weekDateView.backgroundColor = MySpecialColors.DateBackColor
                cell.weekDateText.textColor = MySpecialColors.TextColor
            }
        } else {
            cell.weekDateText.isHidden = true
        }
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let totalWidth = collectionView.frame.width - (16 * 6)
        let width = totalWidth / 7
        return CGSize(width: width, height: 44)
    }
}
