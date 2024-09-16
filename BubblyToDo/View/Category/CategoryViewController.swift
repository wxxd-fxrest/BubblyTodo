//
//  CategoryViewController.swift
//  BubblyToDo
//
//  Created by 밀가루 on 9/15/24.
//

import UIKit

class CategoryViewController: UIViewController {

    let categoryTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "카테고리 이름 입력"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let colorButton: UIButton = {
        let button = UIButton()
        button.setTitle("색상 선택", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var selectedColor: UIColor = .clear

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupUI()
        
        colorButton.addTarget(self, action: #selector(selectColor), for: .touchUpInside)
        
        // 완료 버튼 추가
        setupDoneButton()
    }
    
    func setupUI() {
        view.addSubview(categoryTextField)
        view.addSubview(colorButton)

        NSLayoutConstraint.activate([
            categoryTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            categoryTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            categoryTextField.widthAnchor.constraint(equalToConstant: 250),
            categoryTextField.heightAnchor.constraint(equalToConstant: 40),
            
            colorButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            colorButton.topAnchor.constraint(equalTo: categoryTextField.bottomAnchor, constant: 20),
            colorButton.widthAnchor.constraint(equalToConstant: 250),
            colorButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    func setupDoneButton() {
        // 내비게이션 바에 완료 버튼 추가
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "완료", style: .done, target: self, action: #selector(doneButtonTapped))
    }
    
    @objc func selectColor() {
        let colorPicker = UIColorPickerViewController()
        colorPicker.delegate = self
        colorPicker.selectedColor = selectedColor
        present(colorPicker, animated: true, completion: nil)
    }

    @objc func doneButtonTapped() {
        let categoryName = categoryTextField.text ?? ""
        
        // 선택된 색상의 RGBA 값을 HEX 문자열로 변환
        let colorComponents = selectedColor.cgColor.components ?? [0, 0, 0, 0]
        let red = Int(colorComponents[0] * 255)
        let green = Int(colorComponents[1] * 255)
        let blue = Int(colorComponents[2] * 255)
        let alpha = colorComponents[3]
        
        // HEX 문자열 생성
        let hexColor = String(format: "#%02X%02X%02X", red, green, blue)
        
        if let saveuser = UserDefaults.standard.string(forKey: "useremail") {
            print("saveuser: \(saveuser)") // 저장된 이메일 출력
            // CategoryDTO 생성
            print("카테고리 이름: \(categoryName), 선택된 색상: (R: \(Int(red)), G: \(Int(green)), B: \(Int(blue)), A: \(alpha))")
            print("category: \(categoryName), select Color: \(hexColor)")
            let categoryDTO = CategoryDTO(category: categoryName, categoryColor: hexColor, categoryUser: saveuser)
            print("categoryDTO \(categoryDTO)")
            // 서버에 POST 요청 보내기
            sendCategoryToServer(categoryDTO: categoryDTO)
        }
    }

    // categoryDTO 출력은 잘 됨, 추가가 안 됨
    func sendCategoryToServer(categoryDTO: CategoryDTO) {
        guard let url = URL(string: "http://localhost:8084/category") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let categoryData: [String: Any] = [
            "category": categoryDTO.category,
            "categoryColor": categoryDTO.categoryColor,
            "categoryUser": categoryDTO.categoryUser
        ]
        
        // JSON 인코딩
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: categoryData, options: [])
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
                    print("카테고리 저장 성공")
                } else {
                    // 실패 처리
                    if let data = data, let responseString = String(data: data, encoding: .utf8) {
                        print("카테고리 저장 실패: \(responseString)") // 응답 내용 출력
                    } else {
                        print("카테고리 저장 실패")
                    }
                }
            }
        }
        
        task.resume()
    }

}

extension CategoryViewController: UIColorPickerViewControllerDelegate {
    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        selectedColor = viewController.selectedColor
        colorButton.backgroundColor = selectedColor
    }
}
