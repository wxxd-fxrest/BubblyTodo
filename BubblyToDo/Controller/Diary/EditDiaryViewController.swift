//
//  EditViewController.swift
//  BubblyToDo
//
//  Created by 밀가루 on 9/16/24.
//

import UIKit

class EditDiaryViewController: UIViewController {
    var diaryId: Int64? // 일기 ID 추가
    var diaryContent: String?
    var diaryDate: String?
    var diaryEmoji: String?

    // UI 요소
    private let dateLabel = UILabel()
    private let emojiLabel = UILabel()
    private let contentTextView = UITextView()
    private let saveButton = UIButton()
    private let changeEmojiButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupUI()
        configureUI()
        
        print("diaryContent: diaryId \(diaryId) / \(diaryContent ?? "없음") / diaryDate: \(diaryDate ?? "없음") / diaryEmoji: \(diaryEmoji ?? "없음")")
    }
    
    private func setupUI() {
        // 날짜 레이블
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(dateLabel)
        
        // 이모지 레이블
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(emojiLabel)
        
        // 일기 내용 입력을 위한 UITextView
        contentTextView.translatesAutoresizingMaskIntoConstraints = false
        contentTextView.layer.borderColor = UIColor.lightGray.cgColor
        contentTextView.layer.borderWidth = 1
        contentTextView.layer.cornerRadius = 5
        contentTextView.font = UIFont.systemFont(ofSize: 16)
        view.addSubview(contentTextView)
        
        // 저장 버튼
        saveButton.setTitle("저장", for: .normal)
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.backgroundColor = .blue
        saveButton.layer.cornerRadius = 5
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        view.addSubview(saveButton)
        
        // 이모지 변경 버튼
        changeEmojiButton.setTitle("이모지 변경", for: .normal)
        changeEmojiButton.setTitleColor(.white, for: .normal)
        changeEmojiButton.backgroundColor = .orange
        changeEmojiButton.layer.cornerRadius = 5
        changeEmojiButton.translatesAutoresizingMaskIntoConstraints = false
        changeEmojiButton.addTarget(self, action: #selector(changeEmojiButtonTapped), for: .touchUpInside)
        view.addSubview(changeEmojiButton)
        
        // Auto Layout 설정
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            dateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            emojiLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 10),
            emojiLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            contentTextView.topAnchor.constraint(equalTo: emojiLabel.bottomAnchor, constant: 20),
            contentTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            contentTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            contentTextView.heightAnchor.constraint(equalToConstant: 200),
            
            changeEmojiButton.topAnchor.constraint(equalTo: contentTextView.bottomAnchor, constant: 20),
            changeEmojiButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            changeEmojiButton.widthAnchor.constraint(equalToConstant: 120),
            changeEmojiButton.heightAnchor.constraint(equalToConstant: 40),
            
            saveButton.topAnchor.constraint(equalTo: changeEmojiButton.bottomAnchor, constant: 20),
            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            saveButton.widthAnchor.constraint(equalToConstant: 100),
            saveButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private func configureUI() {
        // 데이터 설정
        dateLabel.text = "날짜: \(diaryDate ?? "없음")"
        emojiLabel.text = "이모지: \(diaryEmoji ?? "없음")"
        contentTextView.text = diaryContent // 기존 일기 내용으로 설정
    }
    
    @objc private func saveButtonTapped() {
        guard let saveuser = UserDefaults.standard.string(forKey: "useremail") else {
            print("Error: useremail is nil")
            return
        }
        
        guard let diaryDate = diaryDate else {
            print("Error: diaryDate is nil")
            return
        }
        
        guard let updatedContent = contentTextView.text else { return }
        
        let updatedDiary = DiaryDTO(
            diaryId: diaryId,
            diary: updatedContent,
            diaryDate: diaryDate,
            diaryEmoji: diaryEmoji ?? "",
            diaryUser: saveuser
        )
        
        DiaryManager.shared.updateDiary(diaryDTO: updatedDiary) { success, errorMessage in
            DispatchQueue.main.async {
                if success {
                    self.navigationController?.popViewController(animated: true)
                } else {
                    print("Error: \(errorMessage ?? "Unknown error")")
                }
            }
        }
    }
    
    @objc private func changeEmojiButtonTapped() {
        // 이모지를 변경하는 로직
        // 예시로 이모지를 랜덤으로 변경하는 방법
        let emojis = ["😀", "😃", "😄", "😅", "😂", "😍", "😎", "🤔", "😴", "😡"]
        if let currentEmoji = diaryEmoji, let currentIndex = emojis.firstIndex(of: currentEmoji) {
            let nextIndex = (currentIndex + 1) % emojis.count
            diaryEmoji = emojis[nextIndex] // 다음 이모지로 변경
        } else {
            diaryEmoji = emojis.randomElement() // 랜덤 이모지로 설정
        }
        emojiLabel.text = "이모지: \(diaryEmoji ?? "없음")" // 레이블 업데이트
    }
}
