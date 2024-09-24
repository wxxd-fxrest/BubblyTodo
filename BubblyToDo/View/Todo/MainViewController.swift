//
//  MainViewController.swift
//  BubblyToDo
//
//  Created by 밀가루 on 9/13/24.
//

import UIKit

class MainViewController: UIViewController {
    
    var todoDTOList: [TodoDTO] = [] // API에서 받아온 투두 리스트
    private var collectionView: UICollectionView!
    private var monthLabel: UILabel!
    
    // 현재 연도와 월을 저장
    private var currentYear: Int {
        return Calendar.current.component(.year, from: Date())
    }
    
    private var currentMonth: Int {
        return Calendar.current.component(.month, from: Date())
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        print("현재 useremail: \(UserDefaults.standard.string(forKey: "useremail") ?? "없음")")
        
        setupNavigationBar()
        setupMonthLabel()
        setupCalendar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        
        // UserDefaults에서 useremail 확인
        checkUserEmail()
    }
    
    private func checkUserEmail() {
        if UserDefaults.standard.string(forKey: "useremail") == nil {
            // useremail이 없으면 ViewController로 이동
            let loginVC = ViewController() // 로그인 화면으로 대체
            self.navigationController?.setViewControllers([loginVC], animated: true)
        } else {
            print("로그인된 useremail: \(UserDefaults.standard.string(forKey: "useremail")!)")
        }
    }
    
    private func setupNavigationBar() {
        // 첫 번째 플러스 버튼 생성
        let plusImage = UIImage(systemName: "plus.app")
        let plusButton1 = UIBarButtonItem(image: plusImage, style: .plain, target: self, action: #selector(plusButton2Tapped))
        
        // 두 번째 플러스 버튼 생성
        let plusButton2 = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(plusButton1Tapped))
        
        // 버튼 색상 설정
        plusButton1.tintColor = .black
        plusButton2.tintColor = .black
        
        // 두 개의 버튼을 오른쪽에 추가
        navigationItem.rightBarButtonItems = [plusButton1, plusButton2]
        
        // 달력 아이콘 생성
        let calendarImage = UIImage(systemName: "calendar")
        let calendarButton = UIBarButtonItem(image: calendarImage, style: .plain, target: self, action: #selector(calendarButtonTapped))
        
        // 로그아웃 버튼 생성
        let logoutButton = UIBarButtonItem(title: "로그아웃", style: .plain, target: self, action: #selector(logoutButtonTapped))
        logoutButton.tintColor = .black // 로그아웃 버튼 색상 설정

        // 왼쪽에 로그아웃 버튼과 달력 버튼 추가
        navigationItem.leftBarButtonItems = [logoutButton, calendarButton]
    }
    
    private func setupMonthLabel() {
        monthLabel = UILabel()
        monthLabel.translatesAutoresizingMaskIntoConstraints = false
        monthLabel.textAlignment = .center
        monthLabel.font = UIFont.boldSystemFont(ofSize: 24)
        monthLabel.text = getCurrentMonth()
        
        view.addSubview(monthLabel)
        
        NSLayoutConstraint.activate([
            monthLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            monthLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            monthLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func getCurrentMonth() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM yyyy" // "January 2023" 형식
        return dateFormatter.string(from: Date())
    }

    private func setupCalendar() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(MainCalendarCell.self, forCellWithReuseIdentifier: MainCalendarCell.identifier)
        
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            collectionView.topAnchor.constraint(equalTo: monthLabel.bottomAnchor, constant: 20),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    // MARK: - Navigation
    @objc func calendarButtonTapped() {
        let caVC = CalendarViewController()
        self.navigationController?.pushViewController(caVC, animated: true)
        print("달력 버튼이 클릭되었습니다.")
    }
    
    @objc func logoutButtonTapped() {
        // UserDefaults에서 useremail 삭제
        UserDefaults.standard.removeObject(forKey: "useremail")
        
        // 삭제 확인
        if UserDefaults.standard.string(forKey: "useremail") == nil {
            print("useremail 삭제 성공")
        } else {
            print("useremail 삭제 실패")
        }

        // 로그인 화면으로 돌아가는 코드
        let loginVC = ViewController() // 로그인 화면으로 대체
        self.navigationController?.setViewControllers([loginVC], animated: true)
        
        print("로그아웃 버튼이 클릭되었습니다.")
    }
    
    @objc func plusButton1Tapped() {
        let caVC = CategoryViewController()
        self.navigationController?.pushViewController(caVC, animated: true)
        print("첫 번째 플러스 버튼이 클릭되었습니다.")
    }
    
    @objc func plusButton2Tapped() {
        let addVC = AddTodoViewController()
        self.navigationController?.pushViewController(addVC, animated: true)
        print("두 번째 플러스 버튼이 클릭되었습니다.")
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 42 // 6주 x 7일
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainCalendarCell.identifier, for: indexPath) as! MainCalendarCell
        
        let day = (indexPath.item % 31) + 1 // 1일부터 31일까지 반복
        cell.configure(with: "\(day)")
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 50) / 7 // 여백을 고려하여 7개의 열로 나누기
        return CGSize(width: width, height: width)
    }

    // 셀 클릭 시 동작
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let day = (indexPath.item % 31) + 1 // 클릭된 날짜
        let date = String(format: "%04d-%02d-%02d", currentYear, currentMonth, day) // "yyyy-MM-dd" 형식으로 날짜 생성
        print("클릭된 날짜: \(date)")
        
        // API 호출
        fetchTodos(for: date)
    }
    
    // MARK: - API 호출
    private func fetchTodos(for date: String) {
        guard let userEmail = UserDefaults.standard.string(forKey: "useremail") else {
            print("저장된 사용자 이메일이 없습니다.")
            return
        }
        
        TodoManager.shared.loadCategories(for: date, userEmail: userEmail) { todoList, error in
            if let error = error {
                print("Error fetching todos: \(error.localizedDescription)")
                return
            }
            if let todoList = todoList {
                print("받은 투두 리스트: \(todoList)")
            }
        }
    }
}

// MARK: - CalendarCell
class MainCalendarCell: UICollectionViewCell {
    static let identifier = "MainCalendarCell"
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(dateLabel)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            dateLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            dateLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
        contentView.layer.borderColor = UIColor.lightGray.cgColor
        contentView.layer.borderWidth = 1
        contentView.layer.cornerRadius = 5
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with date: String) {
        dateLabel.text = date
    }
}
