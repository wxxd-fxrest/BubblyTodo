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
        guard let url = URL(string: "http://localhost:8084/category") else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching categories: \(error)")
                return
            }
            
            guard let data = data else { return }
            
            do {
                let categoryDTOList = try JSONDecoder().decode([CategoryDTO].self, from: data)
                print("Fetched Categories: \(categoryDTOList)") // 추가된 디버깅
                
                self.categoryDictionary = Dictionary(uniqueKeysWithValues: categoryDTOList.map { ($0.category, ($0.categoryColor, $0.categoryId)) })

                self.categories = categoryDTOList.map { $0.category } // 카테고리 이름 배열로 저장
                
                DispatchQueue.main.async {
                    self.categoryPicker.reloadAllComponents()
                }
            } catch {
                print("Error decoding JSON: \(error)")
            }
        }
        
        task.resume()
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
            sendTodoToServer(todoDTO: todoDTO)
        }
    }


    func sendTodoToServer(todoDTO: TodoDTO) {
        guard let url = URL(string: "http://localhost:8084/bubbly-todo/addTodo") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // JSON 데이터 구성
        let todoData: [String: Any] = [
            "todo": todoDTO.todo,
            "todoDate": todoDTO.todoDate, // LocalDate는 문자열로 변환
            "todoState": todoDTO.todoState,
            "todoUser": todoDTO.todoUser,// 사용자 이메일
            "todoCategoryId": todoDTO.todoCategoryId,
            "todoCategory": todoDTO.todoCategory, // 카테고리 이름
            "todoCategoryColor": todoDTO.todoCategoryColor ?? "기본색상" // 카테고리 색상
        ]
        
        // JSON 인코딩
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: todoData, options: [])
        } catch {
            print("Error serializing JSON: \(error)")
            return
        }
        
        // URLSession을 사용하여 요청 보내기
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error sending data: \(error)")
                return
            }
            
            // 서버의 응답 처리
            if let httpResponse = response as? HTTPURLResponse {
                print("HTTP Status Code: \(httpResponse.statusCode)") // 상태 코드 출력
                
                if httpResponse.statusCode == 201 { // 성공적으로 생성된 경우
                    print("ToDo 저장 성공")
                } else {
                    // 실패 처리
                    if let data = data, let responseString = String(data: data, encoding: .utf8) {
                        print("ToDo 저장 실패: \(responseString)") // 응답 내용 출력
                    } else {
                        print("ToDo 저장 실패")
                    }
                }
            }
        }
        
        task.resume()
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
