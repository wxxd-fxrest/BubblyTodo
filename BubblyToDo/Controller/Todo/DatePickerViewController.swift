//
//  DatePickerViewController.swift
//  BubblyToDo
//
//  Created by 밀가루 on 9/30/24.
//

import UIKit
import Then
import SnapKit

class DatePickerViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    private let grabberView = UIView()
    private var viewModel: DatePickerViewModel
    private var calendarCollectionView: UICollectionView!
    private var todoTopView: TodoTopView? // TodoTopView를 참조할 변수 추가
    
    private var currentDate: Date = Date() // 현재 날짜
    private var daysInMonth: [Int] = [] // 현재 월의 날짜 배열
    private var selectedDate: Int? // 선택된 날짜 저장

    lazy var modalView = UIView().then {
        $0.backgroundColor = MySpecialColors.WhiteColor
        $0.layer.cornerRadius = 12 // 모서리 둥글게
    }
    
    // MARK: Arrow View
    lazy var bottomControlStackView: UIStackView = UIFactory.makeStackView(
        arrangedSubviews: [dateText, ArrowStackView],
        axis: .horizontal,
        spacing: 0,
        alignment: .center,
        distribution: .fill
    )
    
    lazy var ArrowStackView: UIStackView = UIFactory.makeStackView(
        arrangedSubviews: [leftArrowImage, rightArrowImage],
        axis: .horizontal,
        spacing: 14,
        alignment: .fill,
        distribution: .fill
    )
    
    let leftArrowImage = UIFactory.makeImageButton(image: "leftArrow", tintColor: MySpecialColors.MainColor)
    let rightArrowImage = UIFactory.makeImageButton(image: "rightArrow", tintColor: MySpecialColors.MainColor)
    
    let dateText = UIFactory.makeLabel(text: "", textColor: MySpecialColors.MainColor, font: UIFont.pretendard(style: .semiBold, size: 20, isScaled: true))
    
    init(viewModel: DatePickerViewModel, todoTopView: TodoTopView) {
        self.viewModel = viewModel
        self.todoTopView = todoTopView // TodoTopView를 초기화 메서드로 전달
        super.init(nibName: nil, bundle: nil)
        
        setupSubviews()
        setupCollectionView()
        
        // 버튼 클릭 액션 추가
        leftArrowImage.addTarget(self, action: #selector(previousMonth), for: .touchUpInside)
        rightArrowImage.addTarget(self, action: #selector(nextMonth), for: .touchUpInside)
        
        updateDaysInMonth() // 초기 날짜 배열 업데이트
        updateDateText() // 초기 날짜 텍스트 업데이트
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        view.addSubview(modalView)

        // bottomControlStackView 추가
        modalView.addSubview(bottomControlStackView)
        
        // 그랩바 추가
        grabberView.backgroundColor = .lightGray
        grabberView.layer.cornerRadius = 2
        modalView.addSubview(grabberView)
        
        modalView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(460) // 높이 설정
            $0.bottom.equalToSuperview() // 화면 하단에 붙도록 설정
        }

        let screenHeight = UIScreen.main.bounds.height
        let topInset: CGFloat = screenHeight >= 896 ? 8 : 16 // iPhone 11 Pro Max, iPhone 12 Pro Max 등의 높이에 따라 조정

        grabberView.snp.makeConstraints {
            $0.top.equalTo(modalView.snp.top).offset(topInset) // 조건에 따라 상단 여백 설정
            $0.centerX.equalToSuperview()
            $0.width.equalTo(40) // 그랩바의 너비
            $0.height.equalTo(4) // 그랩바의 높이
        }

        bottomControlStackView.snp.makeConstraints {
            $0.top.equalTo(grabberView.snp.bottom).offset(16) // 그랩바 아래에 위치
            $0.leading.trailing.equalToSuperview().inset(16) // 여백 설정
            $0.height.equalTo(40) // 높이 설정
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
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 50, height: 50) // 각 날짜의 크기
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 5
        
        calendarCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        calendarCollectionView.backgroundColor = .clear
        calendarCollectionView.delegate = self
        calendarCollectionView.dataSource = self
        
        // 셀 등록
        calendarCollectionView.register(BottomDateCell.self, forCellWithReuseIdentifier: "BottomDateCell") // 식별자 확인

        modalView.addSubview(calendarCollectionView)
        
        calendarCollectionView.snp.makeConstraints {
            $0.top.equalTo(bottomControlStackView.snp.bottom).offset(16) // bottomControlStackView 아래에 위치
            $0.leading.trailing.equalToSuperview().inset(16) // 여백 설정
            $0.height.equalTo(350) // 캘린더 높이 설정
        }
    }
    
    // UICollectionViewDataSource 메서드
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return daysInMonth.count // 현재 월의 날짜 수
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BottomDateCell", for: indexPath) as! BottomDateCell
        let day = daysInMonth[indexPath.item] // 현재 월의 날짜를 가져옴
        cell.configure(with: day) // 날짜 설정

        // 오늘 날짜의 배경색을 빨간색으로 설정
        let dateToCheck = Calendar.current.date(byAdding: .day, value: day - 1, to: currentDate)!
        if Calendar.current.isDateInToday(dateToCheck) {
            cell.dateLabel.backgroundColor = MySpecialColors.MainColor // dateLabel의 배경색을 빨간색으로 설정
            cell.dateLabel.textColor = MySpecialColors.WhiteColor
        } else {
            cell.dateLabel.backgroundColor = MySpecialColors.TermMainColor // 기본 배경색 설정
            cell.dateLabel.textColor = MySpecialColors.TextColor
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedDay = daysInMonth[indexPath.item] // 선택된 날짜
        self.selectedDate = selectedDay // 선택된 날짜 저장

        // 모든 셀의 dateLabel 배경색 초기화
        for item in 0..<daysInMonth.count {
            if let cell = collectionView.cellForItem(at: IndexPath(item: item, section: 0)) as? BottomDateCell {
                cell.dateLabel.backgroundColor = MySpecialColors.TermMainColor // 기본 배경색으로 초기화
            }
        }

        // 선택된 셀의 dateLabel 배경색 변경
        if let cell = collectionView.cellForItem(at: indexPath) as? BottomDateCell {
            cell.dateLabel.backgroundColor = MySpecialColors.MainColor // 선택된 셀의 dateLabel 배경색 변경
            cell.dateLabel.textColor = MySpecialColors.WhiteColor
        }

        // 선택한 날짜의 년, 월, 일 정보 추출
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: currentDate) // 현재 년, 월 가져오기

        // selectedDay는 Int 타입이므로 직접 사용
        let dateComponents = DateComponents(year: components.year, month: components.month, day: selectedDay)
        if let date = calendar.date(from: dateComponents) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy년 MM월 dd일" // 원하는 형식으로 설정
            let formattedDate = dateFormatter.string(from: date) // 포맷팅된 날짜
            
            // TodoTopView로 날짜 전달
            todoTopView?.updateDateLabel(with: formattedDate) // 직접 전달
        }

        // 바텀 시트 닫기
        self.dismiss(animated: true, completion: nil)
    }

    @objc private func previousMonth() {
        currentDate = Calendar.current.date(byAdding: .month, value: -1, to: currentDate) ?? currentDate
        updateDaysInMonth() // 날짜 배열 업데이트
        updateDateText()
        calendarCollectionView.reloadData() // 콜렉션뷰 새로고침
    }

    @objc private func nextMonth() {
        currentDate = Calendar.current.date(byAdding: .month, value: 1, to: currentDate) ?? currentDate
        updateDaysInMonth() // 날짜 배열 업데이트
        updateDateText()
        calendarCollectionView.reloadData() // 콜렉션뷰 새로고침
    }

    private func updateDaysInMonth() {
        let calendar = Calendar.current
        let range = calendar.range(of: .day, in: .month, for: currentDate) // 현재 월의 날 수 가져오기
        daysInMonth = range?.compactMap { $0 } ?? [] // 날짜 배열 업데이트
    }

    private func updateDateText() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월" // 원하는 형식으로 설정
        dateText.text = formatter.string(from: currentDate) // 텍스트 업데이트
    }
}

// 날짜 셀 클래스
class BottomDateCell: UICollectionViewCell {
    lazy var dateLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(dateLabel)
        dateLabel.textAlignment = .center

        dateLabel.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with date: Int) {
        dateLabel.text = "\(date)"
        dateLabel.layer.cornerRadius = 12
        dateLabel.layer.masksToBounds = true
    }
}
