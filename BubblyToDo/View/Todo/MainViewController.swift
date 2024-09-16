//
//  MainViewController.swift
//  BubblyToDo
//
//  Created by 밀가루 on 9/13/24.
//

import UIKit

class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var todoDTOList: [TodoDTO] = [] // API에서 받아온 투두 리스트
    let tableView = UITableView() // 테이블 뷰 생성

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupTableView() // 테이블 뷰 설정
        
        // 첫 번째 플러스 버튼 생성
        let plusImage = UIImage(systemName: "plus.app") // SF Symbols에서 커스텀 아이콘 사용
        let plusButton1 = UIBarButtonItem(image: plusImage, style: .plain, target: self, action: #selector(plusButton2Tapped))
        
        // 두 번째 플러스 버튼 생성 (커스텀 아이콘 사용)
        let plusButton2 = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(plusButton1Tapped))
        
        // 버튼 색상 설정
        plusButton1.tintColor = .black // 첫 번째 버튼 색상
        plusButton2.tintColor = .black // 두 번째 버튼 색상
        
        // 두 개의 버튼을 오른쪽에 추가
        navigationItem.rightBarButtonItems = [plusButton1, plusButton2]
        
        // 달력 아이콘 생성
        let calendarImage = UIImage(systemName: "calendar") // SF Symbols에서 달력 아이콘 사용
        let calendarButton = UIBarButtonItem(image: calendarImage, style: .plain, target: self, action: #selector(calendarButtonTapped))
        
        // 버튼 색상 설정
        calendarButton.tintColor = .black // 달력 버튼 색상
        
        // 왼쪽에 달력 버튼 추가
        navigationItem.leftBarButtonItem = calendarButton
        
        loadToDos() // 카테고리 로드
    }
    
    // 달력 버튼 클릭 시 동작
    @objc func calendarButtonTapped() {
        let caVC = CalendarViewController()
        self.navigationController?.pushViewController(caVC, animated: true)
        print("달력 버튼이 클릭되었습니다.")
    }
    
    func setupTableView() {
        // 테이블 뷰 설정
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "TodoCell")
        
        // 테이블 뷰의 제약 조건 설정
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    func loadToDos() {
        if let saveuser = UserDefaults.standard.string(forKey: "useremail") {
            print("saveuser: \(saveuser)") // 저장된 이메일 출력
            
            TodoManager.shared.loadCategories(for: saveuser) { [weak self] todoDTOList, error in
                if let error = error {
                    print("Error loading categories: \(error.localizedDescription)")
                    return
                }

                guard let todoDTOList = todoDTOList else { return }

                // Main 스레드에서 UI 업데이트
                DispatchQueue.main.async {
                    self?.todoDTOList = todoDTOList // 받아온 데이터를 저장
                    self?.tableView.reloadData() // 테이블 뷰 리로드
                }
            }
        } else {
            print("저장된 사용자 이메일이 없습니다.")
        }
    }

    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoDTOList.count // 데이터 수 반환
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoCell", for: indexPath)
        let todo = todoDTOList[indexPath.row]
        
        // 셀에 투두 내용 설정
        cell.textLabel?.text = todo.todo // todo 필드를 표시
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete // 삭제 스타일 설정
    }
    
    // MARK: - 스와이프 액션 추가
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let editAction = UITableViewRowAction(style: .normal, title: "수정") { (action, index) in
            // 수정할 투두의 ID를 가져옴
            let todoToEdit = self.todoDTOList[indexPath.row]
            
            // todoId가 nil인지 확인
            if let todoId = todoToEdit.todoId {
                // EditTodoViewController로 이동하고 todoId를 전달
                let editVC = EditTodoViewController(todoId: todoId, todo: todoToEdit)
                self.navigationController?.pushViewController(editVC, animated: true)
            } else {
                // todoId가 nil인 경우의 처리
                print("Error: todoId is nil.")
            }
        }
        
        editAction.backgroundColor = .blue // 수정 버튼 색상 설정
        
        let deleteAction = UITableViewRowAction(style: .destructive, title: "삭제") { (action, index) in
            // 삭제 로직
            let alert = UIAlertController(title: "삭제 확인", message: "정말로 이 항목을 삭제하시겠습니까?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "삭제", style: .destructive, handler: { _ in
                if let todoId = self.todoDTOList[indexPath.row].todoId {
                    self.deleteTodo(todoId: todoId) // 클로저를 전달하지 않도록 수정
                }
            }))
            self.present(alert, animated: true, completion: nil)
        }
        
        return [editAction, deleteAction] // 수정 버튼과 삭제 버튼 모두 반환
    }

    func deleteTodo(todoId: Int64) {
        TodoManager.shared.deleteTodoFromServer(todoId: todoId) { success in
            DispatchQueue.main.async {
                if success {
                    print("할 일이 성공적으로 삭제되었습니다.")
                    // 여기서 테이블 뷰를 업데이트하거나 필요한 UI 조치를 취합니다.
                    if let index = self.todoDTOList.firstIndex(where: { $0.todoId == todoId }) {
                        self.todoDTOList.remove(at: index)
                        self.tableView.reloadData() // 테이블 뷰 리로드
                    }
                } else {
                    print("할 일 삭제에 실패했습니다.")
                    // 실패 메시지를 사용자에게 표시하는 등의 조치를 취합니다.
                    let errorAlert = UIAlertController(title: "오류", message: "삭제할 수 없습니다.", preferredStyle: .alert)
                    errorAlert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
                    self.present(errorAlert, animated: true, completion: nil)
                }
            }
        }
    }
    
    // MARK: - Navigation
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
