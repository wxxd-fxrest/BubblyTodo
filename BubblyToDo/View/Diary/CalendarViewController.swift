//
//  CalendarViewController.swift
//  BubblyToDo
//
//  Created by 밀가루 on 9/16/24.
//

import UIKit

class CalendarViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    var collectionView: UICollectionView!
    var currentDate: Date = Date() // 현재 날짜
    let calendar = Calendar.current
    var diaryDates: [String] = [] // 서버에서 가져온 날짜 목록
    var diaryContents: [DiaryDTO] = [] // 전체 다이어리 데이터를 저장할 배열


    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupNavigationBar()
        setupCollectionView()
        updateTitle() // 타이틀 업데이트
        
        fetchDiaryDates() // 일기 날짜 가져오기
    }

    func setupNavigationBar() {
        let leftBarButton = UIBarButtonItem(title: "이전", style: .plain, target: self, action: #selector(previousMonth))
        let rightBarButton = UIBarButtonItem(title: "다음", style: .plain, target: self, action: #selector(nextMonth))
        
        let backButton = UIBarButtonItem(title: "뒤로", style: .plain, target: self, action: #selector(backButtonTapped))
        
        navigationItem.leftBarButtonItems = [backButton, leftBarButton] // 뒤로가기 버튼을 왼쪽에 추가
        navigationItem.rightBarButtonItem = rightBarButton
    }

    func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CalendarCell.self, forCellWithReuseIdentifier: "CalendarCell")
        collectionView.backgroundColor = .white
        
        view.addSubview(collectionView)
    }

    // 일기 날짜 목록 가져오기
    func fetchDiaryDates() {
        if let saveuser = UserDefaults.standard.string(forKey: "useremail") {
            print("saveuser: \(saveuser)") // 저장된 이메일 출력
            
            // DiaryManager를 사용하여 다이어리 날짜 가져오기
            DiaryManager.shared.fetchDiaryDates(for: saveuser) { diaryDTOList, errorMessage in
                DispatchQueue.main.async {
                    if let dtos = diaryDTOList {
                        // 전체 다이어리 DTO 배열을 저장
                        self.diaryDates = dtos.map { $0.diaryDate } // 날짜 업데이트
                        self.diaryContents = dtos // 전체 DTO 배열 저장 (필요 시 사용)

                        // 가져온 전체 데이터 출력
                        print("Fetched Diary DTOs: \(dtos)") // 콘솔에 전체 데이터 출력
                        
                        // 데이터 업데이트 후 리로드
                        self.collectionView.reloadData()
                    } else {
                        print(errorMessage ?? "알 수 없는 오류")
                    }
                }
            }
        }
    }

    // UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let daysInMonth = numberOfDaysInMonth(date: currentDate)
        return daysInMonth + firstWeekdayOfMonth(date: currentDate) - 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CalendarCell", for: indexPath) as! CalendarCell
        
        let day = indexPath.item - firstWeekdayOfMonth(date: currentDate) + 2
        if day > 0 && day <= numberOfDaysInMonth(date: currentDate) {
            cell.label.text = "\(day)"
            
            // 날짜 포맷팅
            let year = currentDate.year()
            let month = currentDate.month()
            let formattedDate = String(format: "%04d-%02d-%02d", year, month, day) // YYYY-MM-DD 형식
            
            // 동그라미 표시
            if diaryDates.contains(formattedDate) {
                cell.backgroundColor = UIColor.blue // 파란 동그라미 표시
                cell.layer.cornerRadius = cell.frame.width / 2 // 동그라미 형태
                cell.layer.masksToBounds = true
            } else {
                cell.backgroundColor = .clear // 기본 배경
            }
        } else {
            cell.label.text = "" // 빈 셀
            cell.backgroundColor = .clear // 빈 셀은 투명하게
        }
        
        return cell
    }

    // UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 50) / 7 // 7개 열
        return CGSize(width: width, height: width)
    }

    // 셀 클릭 시 DiaryDetailViewController로 이동
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let day = indexPath.item - firstWeekdayOfMonth(date: currentDate) + 2
        if day > 0 && day <= numberOfDaysInMonth(date: currentDate) {
            let diaryDetailVC = DiaryDetailViewController()
            
            // 날짜 포맷팅
            let year = currentDate.year()
            let month = currentDate.month()
            let formattedDate = String(format: "%04d-%02d-%02d", year, month, day) // YYYY-MM-DD 형식
            
            diaryDetailVC.diaryDate = formattedDate // 날짜 설정
            
            // 선택된 날짜에 해당하는 다이어리 DTO 가져오기
            if let index = diaryContents.firstIndex(where: { $0.diaryDate == formattedDate }) {
                let selectedDiary = diaryContents[index]
                diaryDetailVC.diaryContent = selectedDiary.diary // 일기 내용 설정
                diaryDetailVC.diaryEmoji = selectedDiary.diaryEmoji // 이모지 설정
                diaryDetailVC.diaryId = selectedDiary.diaryId // ID 설정 (필요 시)
            }
            
            navigationController?.pushViewController(diaryDetailVC, animated: true)
        }
    }
    
    // 월 변경 메서드
    @objc func previousMonth() {
        currentDate = calendar.date(byAdding: .month, value: -1, to: currentDate)!
        collectionView.reloadData()
        updateTitle() // 타이틀 업데이트
    }

    @objc func nextMonth() {
        currentDate = calendar.date(byAdding: .month, value: 1, to: currentDate)!
        collectionView.reloadData()
        updateTitle() // 타이틀 업데이트
    }

    // 타이틀 업데이트 메서드
    func updateTitle() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY년 M월" // 원하는 형식으로 설정
        navigationItem.title = dateFormatter.string(from: currentDate)
    }

    // 뒤로가기 버튼 동작
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }

    // Helper Methods
    func numberOfDaysInMonth(date: Date) -> Int {
        return calendar.range(of: .day, in: .month, for: date)!.count
    }

    func firstWeekdayOfMonth(date: Date) -> Int {
        let components = calendar.dateComponents([.year, .month], from: date)
        let firstOfMonth = calendar.date(from: components)!
        return calendar.component(.weekday, from: firstOfMonth)
    }
}

// Custom UICollectionViewCell
class CalendarCell: UICollectionViewCell {
    let label = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupCell() {
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
        // Cell styling
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.lightGray.cgColor
        contentView.layer.cornerRadius = 5
    }
}

// Extension to get year and month
extension Date {
    func year() -> Int {
        return Calendar.current.component(.year, from: self)
    }
    
    func month() -> Int {
        return Calendar.current.component(.month, from: self)
    }
}
