//
//  AddTodoController.swift
//  BubblyToDo
//
//  Created by 밀가루 on 9/15/24.
//

import UIKit

class AddTodoViewController: UIViewController {

    let todoTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "할 일 내용을 입력하세요"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .dateAndTime
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        return datePicker
    }()
    
    let categoryPicker: UIPickerView = {
        let picker = UIPickerView()
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()

    var categoryDictionary: [String: (String?, Int64?)] = [:] // 카테고리 색상과 ID 저장
    var selectedCategory: String?
    var categories: [String] = [] // 카테고리 이름을 저장할 배열

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        loadCategories() // 카테고리 목록 불러오기

        categoryPicker.delegate = self
        categoryPicker.dataSource = self

        setupDoneButton()
    }
    
    func setupUI() {
        view.addSubview(todoTextField)
        view.addSubview(datePicker)
        view.addSubview(categoryPicker)
        
        NSLayoutConstraint.activate([
            todoTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            todoTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            todoTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            todoTextField.heightAnchor.constraint(equalToConstant: 40),
            
            datePicker.topAnchor.constraint(equalTo: todoTextField.bottomAnchor, constant: 20),
            datePicker.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            datePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            categoryPicker.topAnchor.constraint(equalTo: datePicker.bottomAnchor, constant: 20),
            categoryPicker.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            categoryPicker.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            categoryPicker.heightAnchor.constraint(equalToConstant: 400),
        ])
    }
    
    func setupDoneButton() {
        // 내비게이션 바에 완료 버튼 추가
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "완료", style: .done, target: self, action: #selector(doneButtonTapped))
    }
    
    func loadCategories() {
        if let saveuser = UserDefaults.standard.string(forKey: "useremail") {
            print("saveuser: \(saveuser)") // 저장된 이메일 출력
            
            CategoryManager.shared.loadCategories(for: saveuser) { [weak self] categoryDTOList, error in
                if let error = error {
                    print("Error loading categories: \(error.localizedDescription)")
                    return
                }

                if let categoryDTOList = categoryDTOList {
                    DispatchQueue.main.async {
                        self?.categoryDictionary = Dictionary(uniqueKeysWithValues: categoryDTOList.map { ($0.category, ($0.categoryColor, $0.categoryId)) })
                        self?.categories = categoryDTOList.map { $0.category } // 카테고리 이름 배열로 저장
                        self?.categoryPicker.reloadAllComponents() // 피커 뷰 리로드
                    }
                }
            }
        } else {
            print("저장된 사용자 이메일이 없습니다.")
        }
    }

    @objc func doneButtonTapped() {
        guard let todoText = todoTextField.text, !todoText.isEmpty, let selectedCategory = selectedCategory else {
            print("할 일 내용 또는 카테고리를 선택하세요.")
            return
        }

        let selectedDate = datePicker.date
        
        // 날짜를 문자열로 변환
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd" // 원하는 날짜 형식 설정
        let dateString = dateFormatter.string(from: selectedDate) // LocalDate를 String으로 변환

        // 카테고리 색상과 ID 가져오기
        guard let (categoryColor, todoCategoryId) = categoryDictionary[selectedCategory] else {
            print("선택한 카테고리의 정보가 없습니다.")
            return
        }

        if let saveuser = UserDefaults.standard.string(forKey: "useremail") {
            // 할 일 DTO 생성
            let todoDTO = TodoDTO(
                todo: todoText,
                todoDate: dateString, // 변환된 문자열 사용
                todoState: false,
                todoUser: saveuser,
                todoCategoryId: todoCategoryId, // 안전하게 언래핑된 값 사용
                todoCategory: selectedCategory,
                todoCategoryColor: categoryColor ?? "기본색상"
            )
            
            print("todoDTO : \(todoDTO)")
            
            // 서버에 저장하는 코드 추가
            TodoManager.shared.sendTodoToServer(todoDTO: todoDTO) { success, message in
                DispatchQueue.main.async {
                    if success {
                        print("ToDo 저장 성공: \(message ?? "")")
                        // 추가적인 UI 업데이트가 필요한 경우 여기에 작성
                    } else {
                        print("ToDo 저장 실패: \(message ?? "알 수 없는 오류")")
                    }
                }
            }
        }
    }
}

// UIPickerViewDelegate 및 UIPickerViewDataSource 확장
extension AddTodoViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1 // 컴포넌트 개수
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categories.count // 카테고리 개수
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categories[row] // 카테고리 이름 반환
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedCategory = categories[row] // 선택된 카테고리 저장
    }
}
