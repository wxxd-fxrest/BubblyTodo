//
//  TodoViewController.swift
//  BubblyToDo
//
//  Created by 밀가루 on 9/27/24.
//

import UIKit
import SnapKit

class TodoViewController: UIViewController {
    private var todoTopView = TodoTopView()
    private var selectedDate: Date? // 선택된 날짜를 Date 타입으로 변경
    // 날짜 로드 메서드
    private var dates: [String] = [] // 날짜 배열 추가
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = MySpecialColors.WhiteColor
        setupTodoTopUI()
        setupView()
    }
    
    private func setupView() {
        // UILabel에 Tap Gesture Recognizer 추가
        todoTopView.dateStackView.isUserInteractionEnabled = true // 사용자 상호작용을 활성화
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dateSelectTapped))
        todoTopView.dateStackView.addGestureRecognizer(tapGesture)
        
        todoTopView.leftArrowImage.addTarget(self, action: #selector(leftArrowTapped), for: .touchUpInside)
        todoTopView.rightArrowImage.addTarget(self, action: #selector(rightArrowTapped), for: .touchUpInside)
    }
    
    private func setupTodoTopUI() {
        // todoTopView를 부모 뷰에 추가
        view.addSubview(todoTopView)
        
        // 제약 조건 설정
        todoTopView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(260)
        }
    }
    
    @objc func dateSelectTapped() {
        let datePickerViewModel = DatePickerViewModel(selectedDate: selectedDate ?? Date())
        
        // TodoTopView 인스턴스를 전달
        let datePickerVC = DatePickerViewController(viewModel: datePickerViewModel, todoTopView: self.todoTopView)

        // 바텀 시트 스타일 설정
        if #available(iOS 15.0, *) {
            datePickerVC.modalPresentationStyle = .pageSheet // 페이지 시트 스타일 설정
            datePickerVC.sheetPresentationController?.detents = [
                .medium(), // 중간 크기
                .large()   // 큰 크기
            ]
        }

        present(datePickerVC, animated: true, completion: nil)
    }

    @objc private func leftArrowTapped() {
        changeMonth(by: -1)
    }

    // 오른쪽 화살표 클릭 시 다음 달
    @objc private func rightArrowTapped() {
        changeMonth(by: 1)
    }

    private func changeMonth(by offset: Int) {
        guard let currentDate = selectedDate else { return } // 선택된 날짜가 nil인 경우 리턴
        var components = Calendar.current.dateComponents([.year, .month, .day], from: currentDate)
        components.month! += offset
        
        // 새로운 선택된 날짜를 설정합니다.
        if let newDate = Calendar.current.date(from: components) {
            selectedDate = newDate
            loadDates(for: components.year!, month: components.month!) // 해당 월의 날짜 로드
            updateDateText() // 날짜 텍스트 업데이트
        }
    }

    func loadDates(for year: Int, month: Int) {
        dates = datesForMonth(year: year, month: month) // 날짜를 로드하는 메서드 호출
        todoTopView.weekCollectionView.reloadData() // 콜렉션뷰 새로고침
        todoTopView.weekCollectionView.showsHorizontalScrollIndicator = false
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

    // 날짜 텍스트 업데이트 메서드
    func updateDateText() {
        guard let date = selectedDate else { return }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 MM월 dd일"
        todoTopView.dateText.text = dateFormatter.string(from: date) // 선택된 날짜로 업데이트
    }
}
