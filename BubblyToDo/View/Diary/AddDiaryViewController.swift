//
//  AddDiaryViewController.swift
//  BubblyToDo
//
//  Created by 밀가루 on 9/16/24.
//

import UIKit

class AddDiaryViewController: UIViewController {
    var diaryDate: String? // 추가된 프로퍼티

    private let contentTextView = UITextView()
    private let dateTextView = UILabel() // UITextView로 날짜 입력
    private let emojiButton = UIButton()
    private let saveButton = UIButton()
    
    private var selectedEmoji: String = "😀" // 기본 이모지 설정

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        setupUI()
        configureDateLabel()
    }

    private func setupUI() {
        // 일기 내용 입력을 위한 UITextView
        contentTextView.translatesAutoresizingMaskIntoConstraints = false
        contentTextView.layer.borderColor = UIColor.lightGray.cgColor
        contentTextView.layer.borderWidth = 1
        contentTextView.layer.cornerRadius = 5
        contentTextView.font = UIFont.systemFont(ofSize: 16)
        view.addSubview(contentTextView)
        
        // 날짜 입력을 위한 UITextView
         dateTextView.translatesAutoresizingMaskIntoConstraints = false
         dateTextView.layer.borderColor = UIColor.lightGray.cgColor
         dateTextView.layer.borderWidth = 1
         dateTextView.layer.cornerRadius = 5
         dateTextView.font = UIFont.systemFont(ofSize: 16)
         view.addSubview(dateTextView)
        
        // 이모지 선택 버튼
        emojiButton.setTitle("이모지 선택: \(selectedEmoji)", for: .normal)
        emojiButton.setTitleColor(.blue, for: .normal)
        emojiButton.addTarget(self, action: #selector(selectEmoji), for: .touchUpInside)
        emojiButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(emojiButton)
        
        // 저장 버튼
        saveButton.setTitle("저장", for: .normal)
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.backgroundColor = .blue
        saveButton.layer.cornerRadius = 5
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        view.addSubview(saveButton)
        
        // Auto Layout 설정
        NSLayoutConstraint.activate([
            contentTextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            contentTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            contentTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            contentTextView.heightAnchor.constraint(equalToConstant: 150),
            
            dateTextView.topAnchor.constraint(equalTo: contentTextView.bottomAnchor, constant: 20),
            dateTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            dateTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            emojiButton.topAnchor.constraint(equalTo: dateTextView.bottomAnchor, constant: 20),
            emojiButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            saveButton.topAnchor.constraint(equalTo: emojiButton.bottomAnchor, constant: 20),
            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            saveButton.widthAnchor.constraint(equalToConstant: 100),
            saveButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private func configureDateLabel() {
        // diaryDate가 설정된 경우 UILabel에 텍스트 설정
        if let date = diaryDate {
            dateTextView.text = "\(date)"
        } else {
            dateTextView.text = "날짜가 없습니다."
        }
    }

    @objc private func selectEmoji() {
        let emojiList = ["😀", "😃", "😄", "😅", "😂", "😍", "😎", "🤔", "😴", "😡"]
        
        let alertController = UIAlertController(title: "이모지 선택", message: nil, preferredStyle: .actionSheet)
        
        for emoji in emojiList {
            alertController.addAction(UIAlertAction(title: emoji, style: .default, handler: { _ in
                self.selectedEmoji = emoji
                self.emojiButton.setTitle("이모지 선택: \(emoji)", for: .normal)
            }))
        }
        
        alertController.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        
        present(alertController, animated: true, completion: nil)
    }

    @objc private func saveButtonTapped() {
        guard let diaryContent = contentTextView.text,
              let diaryDate = dateTextView.text else { return }

        let newDiary = DiaryDTO(diary: diaryContent, diaryDate: diaryDate, diaryEmoji: selectedEmoji)
        
        // API 호출
        let urlString = "http://localhost:8084/addDiary"
        guard let url = URL(string: urlString) else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            let jsonData = try JSONEncoder().encode(newDiary)
            request.httpBody = jsonData
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Error adding diary: \(error)")
                    return
                }
                
                guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                    print("Server error")
                    return
                }
                
                DispatchQueue.main.async {
                    // 성공적으로 추가된 후 이전 화면으로 돌아가기
                    self.navigationController?.popViewController(animated: true)
                }
            }
            
            task.resume()
        } catch {
            print("Error encoding diary: \(error)")
        }
    }
}
