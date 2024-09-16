//
//  DiaryDetailViewController.swift
//  BubblyToDo
//
//  Created by 밀가루 on 9/16/24.
//

import UIKit

class DiaryDetailViewController: UIViewController {
    
    var diaryId: Int64?
    var diaryDate: String? // 선택된 날짜를 받을 변수
    var diaryContent: String? // 일기 내용을 저장할 변수
    var diaryEmoji: String? // 일기 이모지를 저장할 변수
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        let plusButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(plusButtonTapped))
        
        // 버튼 색상 설정
        plusButton.tintColor = .black // 두 번째 버튼 색상
        
        navigationItem.rightBarButtonItems = [plusButton]
        
        // 날짜, 이모지, 내용을 가져오기
         if let diaryId = diaryId {
             fetchDiaryContent(diaryId: diaryId) { diaryDTO, errorMessage in
                 DispatchQueue.main.async {
                     if let diaryDTO = diaryDTO {
                         self.diaryContent = diaryDTO.diary
                         self.diaryDate = diaryDTO.diaryDate
                         self.diaryEmoji = diaryDTO.diaryEmoji
                         self.displayDiaryContent() // UI 업데이트
                     } else if let error = errorMessage {
                         print("Error: \(error)") // 오류 메시지 출력
                     }
                 }
             }
         }
    }
    
    func printDiaryContent() {
        if let content = diaryContent {
            print("Diary Content: \(content)") // 일기 내용 프린트
        } else {
            print("No diary content available.")
        }
    }
    
    func fetchDiaryContent(diaryId: Int64, completion: @escaping (DiaryDTO?, String?) -> Void) {
        DiaryManager.shared.fetchDiaryContent(diaryId: diaryId, completion: completion)
    }

    func displayDiaryContent() {
        // 이모지 레이블
        let emojiLabel = UILabel()
        emojiLabel.text = diaryEmoji
        emojiLabel.font = UIFont.systemFont(ofSize: 48) // 이모지를 크게 표시
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // 날짜 레이블
        let dateLabel = UILabel()
        dateLabel.text = diaryDate
        dateLabel.font = UIFont.systemFont(ofSize: 24)
        dateLabel.textAlignment = .center
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // 일기 내용 레이블
        let contentLabel = UILabel()
        contentLabel.text = diaryContent
        contentLabel.font = UIFont.systemFont(ofSize: 18)
        contentLabel.numberOfLines = 0 // 여러 줄 지원
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // 뷰에 추가
        view.addSubview(emojiLabel)
        view.addSubview(dateLabel)
        view.addSubview(contentLabel)
        
        // Auto Layout 설정
        NSLayoutConstraint.activate([
            emojiLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            emojiLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            dateLabel.topAnchor.constraint(equalTo: emojiLabel.bottomAnchor, constant: 20),
            dateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            contentLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 20),
            contentLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            contentLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    // MARK: - Navigation
    @objc func plusButtonTapped() {
        print("추가 버튼이 클릭되었습니다.")
        
        if let diaryId = diaryId {
            fetchDiaryContent(diaryId: diaryId) { [weak self] diaryDTO, errorMessage in
                guard let self = self else { return } // self에 대한 강한 참조를 방지

                DispatchQueue.main.async {
                    if let diaryDTO = diaryDTO {
                        // 다이어리 내용을 업데이트하고 편집 화면으로 전환
                        self.diaryId = diaryDTO.diaryId
                        self.diaryContent = diaryDTO.diary
                        self.diaryDate = diaryDTO.diaryDate
                        self.diaryEmoji = diaryDTO.diaryEmoji
                        self.displayDiaryContent() // UI 업데이트
                        
                        let editDiaryVC = EditDiaryViewController()
                        editDiaryVC.diaryId = self.diaryId
                        editDiaryVC.diaryContent = self.diaryContent // 다이어리 내용 전달
                        editDiaryVC.diaryDate = self.diaryDate // 다이어리 날짜 전달
                        editDiaryVC.diaryEmoji = self.diaryEmoji // 다이어리 이모지 전달
                        
                        self.navigationController?.pushViewController(editDiaryVC, animated: true)
                    } else if let error = errorMessage {
                        print("Error: \(error)") // 오류 메시지 출력
                        let addDiaryVC = AddDiaryViewController()
                        addDiaryVC.diaryDate = self.diaryDate // diaryDate 전달
                        self.navigationController?.pushViewController(addDiaryVC, animated: true)
                    }
                }
            }
        } else {
            // diaryId가 nil인 경우 새 다이어리 추가 화면으로 이동
            let addDiaryVC = AddDiaryViewController()
            addDiaryVC.diaryDate = self.diaryDate // diaryDate 전달
            navigationController?.pushViewController(addDiaryVC, animated: true)
        }
    }
}
