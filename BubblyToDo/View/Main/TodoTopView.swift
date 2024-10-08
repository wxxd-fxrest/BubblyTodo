//
//  TodoTobView.swift
//  BubblyToDo
//
//  Created by 밀가루 on 9/27/24.
//

import UIKit
import SnapKit

class TodoTopView: UIView {
    let weekDays = ["일", "월", "화", "수", "목", "금", "토"]
    private var dates: [String] = [] // 날짜 배열
    private var selectedDate: Date? // 선택된 날짜를 Date 타입으로 변경
    
    lazy var topStackView: UIStackView = UIFactory.makeStackView(
        arrangedSubviews: [dateStackView, arrowStackView],
        axis: .horizontal,
        spacing: 0,
        alignment: .fill,
        distribution: .equalCentering
    )
    
    // MARK: Date View
    lazy var dateStackView: UIStackView = UIFactory.makeStackView(
        arrangedSubviews: [dateText, dateImage],
        axis: .horizontal,
        spacing: 10,
        alignment: .fill,
        distribution: .fill
    )
    
    let dateText = UIFactory.makeLabel(text: "", textColor: MySpecialColors.MainColor, font: UIFont.pretendard(style: .semiBold, size: 20, isScaled: true))
    let dateImage = UIFactory.makeImageView(systemName: "calendar", contentMode: .scaleAspectFit, color: MySpecialColors.MainColor)
    
    // MARK: Arrow View
    lazy var arrowStackView: UIStackView = UIFactory.makeStackView(
        arrangedSubviews: [leftArrowImage, rightArrowImage],
        axis: .horizontal,
        spacing: 0,
        alignment: .fill,
        distribution: .fill
    )
    
    let leftArrowImage = UIFactory.makeImageButton(image: "leftArrow", tintColor: MySpecialColors.MainColor)
    let rightArrowImage = UIFactory.makeImageButton(image: "rightArrow", tintColor: MySpecialColors.MainColor)
    
    // MARK: Weekday View
    lazy var weekDayStackView: UIStackView = {
        let stackView = UIFactory.makeStackView(
            arrangedSubviews: weekDayLabels,
            axis: .horizontal,
            spacing: 0,
            alignment: .fill,
            distribution: .fillEqually // 각 요일의 너비를 동일하게 설정
        )
        return stackView
    }()
    
    // 요일 레이블 생성
    var weekDayLabels: [UILabel] {
        weekDays.map { day in
            let label = UIFactory.makeLabel(text: day, textColor: MySpecialColors.TextColor, font: UIFont.pretendard(style: .regular, size: 12, isScaled: true))
            label.textAlignment = .center // 중앙 정렬
            return label
        }
    }
    
    // MARK: Collection View
    lazy var weekCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 0
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()
    
    // MARK: Progress Bar
    lazy var progressView =  UIFactory.makeView(backgroundColor: MySpecialColors.TermMainColor, cornerRadius: 8)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTopUI()
        setupWeekUI()
        setupCollectionView() // CollectionView 설정
        loadDates(for: 2024, month: 9) // 원하는 연도와 월로 설정
        updateDateText() // 오늘 날짜로 초기화
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadDates(for year: Int, month: Int) {
        dates = datesForMonth(year: year, month: month)
        weekCollectionView.reloadData()
        weekCollectionView.showsHorizontalScrollIndicator = false
    }
    
    func datesForMonth(year: Int, month: Int) -> [String] {
        var dates: [String] = []
        let calendar = Calendar.current
        var dateComponents = DateComponents(year: year, month: month)
        
        // 첫 번째 날짜를 가져옵니다.
        guard let firstDate = calendar.date(from: dateComponents) else { return [] }
        
        let range = calendar.range(of: .day, in: .month, for: firstDate)!
        let firstWeekday = calendar.component(.weekday, from: firstDate) // 1(일) ~ 7(토)
        let totalDays = range.count
        
        // 첫 번째 주의 빈 날짜 추가
        for _ in 1..<firstWeekday {
            dates.append("") // 빈 문자열 추가
        }
        
        // 실제 날짜 추가
        for day in 1...totalDays {
            dates.append("\(day)")
        }
        
        return dates
    }
    
    func setupTopUI() {
        addSubviews(topStackView)
        
        topStackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(8)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(30)
        }
        
        dateImage.snp.makeConstraints {
            $0.height.equalTo(24)
            $0.width.equalTo(24)
        }
        
        leftArrowImage.snp.makeConstraints {
            $0.height.equalTo(30)
            $0.width.equalTo(30)
        }
        
        rightArrowImage.snp.makeConstraints {
            $0.height.equalTo(30)
            $0.width.equalTo(30)
        }
    }
    
    func setupWeekUI() {
        addSubviews(weekDayStackView)
        
        weekDayStackView.snp.makeConstraints {
            $0.top.equalTo(topStackView.snp.bottom).offset(8) // topStackView 아래에 배치
            $0.leading.trailing.equalToSuperview().inset(16) // 양쪽 여백 16
            $0.height.equalTo(28) // 적절한 높이 설정
        }
    }
    
    func setupCollectionView() {
        addSubviews(weekCollectionView)
        
        weekCollectionView.backgroundColor = .clear
        weekCollectionView.dataSource = self
        weekCollectionView.delegate = self
        weekCollectionView.register(DateCell.self, forCellWithReuseIdentifier: "DateCell")
        
        weekCollectionView.snp.makeConstraints {
            $0.top.equalTo(weekDayStackView.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(44) // 날짜 행의 높이 설정
        }
        
        weekCollectionView.isPagingEnabled = true // 스와이프 시 페이지 전환
    }
    
    func updateDateText() {
        // 오늘 날짜를 selectedDate로 설정
        selectedDate = Date() // 현재 날짜로 설정
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 MM월 dd일" // 원하는 형식으로 설정
        dateText.text = dateFormatter.string(from: selectedDate!) // 선택된 날짜로 업데이트
    }
    
    // 날짜 업데이트 메서드 추가
    func updateDateLabel(with date: String) {
        dateText.text = date // 선택된 날짜를 표시
    }
}

// MARK: UICollectionViewDataSource, UICollectionViewDelegate
extension TodoTopView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dates.count / 7 + (dates.count % 7 > 0 ? 1 : 0) // 총 페이지 수
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7 // 각 페이지에 7개 날짜 표시
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DateCell", for: indexPath) as! DateCell
        let index = indexPath.section * 7 + indexPath.item
        
        if index < dates.count {
            let dateString = dates[index]
            cell.weekDateText.text = dateString
            cell.weekDateText.isHidden = dateString.isEmpty // 빈 날짜는 숨기기
            
            // 오늘 날짜 확인
            let today = Calendar.current.component(.day, from: Date())
            if let day = Int(dateString), day == today {
                cell.weekDateView.backgroundColor = MySpecialColors.MainColor // 오늘 날짜의 배경색을 파란색으로 설정
                cell.weekDateText.textColor = MySpecialColors.WhiteColor // 텍스트 색상도 흰색으로 변경
            } else {
                cell.weekDateView.backgroundColor = dateString.isEmpty ? .clear : MySpecialColors.DateBackColor // 일반 색상 설정
                cell.weekDateText.textColor = MySpecialColors.TextColor // 기본 텍스트 색상
            }
        } else {
            cell.weekDateText.isHidden = true // 남은 날짜가 없을 경우 숨김
            cell.weekDateView.backgroundColor = .clear
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // 전체 너비 계산
        let totalWidth = collectionView.frame.width - (16 * 6) // 96은 셀 간의 간격 (16 * 6)
        let width = totalWidth / 7 // 각 날짜의 너비 설정
        return CGSize(width: width, height: 44) // 날짜 셀의 크기
    }
    
    // 사용자가 날짜를 선택했을 때 호출되는 메서드
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = indexPath.section * 7 + indexPath.item
        if index < dates.count {
            let dateString = dates[index]
            
            // 선택된 날짜의 년, 월, 일 정보 추출
            let calendar = Calendar.current
            let year = 2024 // 현재 연도를 적절히 설정
            let month = 9 // 현재 월을 적절히 설정
            
            if let day = Int(dateString) {
                let dateComponents = DateComponents(year: year, month: month, day: day)
                if let date = calendar.date(from: dateComponents) {
                    selectedDate = date // Date로 저장
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy.MM.dd" // 원하는 형식으로 설정
                    dateText.text = dateFormatter.string(from: date) // 선택한 날짜로 업데이트
                }
            }
        }
    }
}

// MARK: DateCell
class DateCell: UICollectionViewCell {
    lazy var weekDateView = UIFactory.makeView(backgroundColor: MySpecialColors.DateBackColor, cornerRadius: 8)
    lazy var weekDateText = UIFactory.makeLabel(text: "01", textColor: MySpecialColors.TextColor, font: UIFont.pretendard(style: .regular, size: 18, isScaled: true))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(weekDateView)
        weekDateView.addSubview(weekDateText)
        
        weekDateView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        weekDateText.snp.makeConstraints {
            $0.center.equalTo(weekDateView)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
