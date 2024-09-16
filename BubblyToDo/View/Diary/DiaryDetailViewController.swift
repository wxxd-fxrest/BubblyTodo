//
//  DiaryDetailViewController.swift
//  BubblyToDo
//
//  Created by 밀가루 on 9/16/24.
//

import UIKit

class DiaryDetailViewController: UIViewController {
    
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
        fetchDiaryContent()
    }
    
    func fetchDiaryContent() {
        guard let diaryDate = diaryDate else { return }
        
        let urlString = "http://localhost:8084/diary/\(diaryDate)"
        guard let url = URL(string: urlString) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching diary: \(error)")
                return
            }
            
            guard let data = data else { return }
            do {
                // JSON 디코딩
                let diaryDTO = try JSONDecoder().decode(DiaryDTO.self, from: data)
                self.diaryContent = diaryDTO.diary // 일기 내용
                self.diaryDate = diaryDTO.diaryDate // 일기 날짜
                self.diaryEmoji = diaryDTO.diaryEmoji // 일기 이모지
                
                // UI 업데이트는 메인 스레드에서 수행
                DispatchQueue.main.async {
                    self.displayDiaryContent()
                }
            } catch {
                self.diaryContent = "아직 일기가 없어요!"// 일기 내용
                self.diaryDate = diaryDate // 일기 날짜
                print("Error decoding diary: \(error)")
                // UI 업데이트는 메인 스레드에서 수행
                DispatchQueue.main.async {
                    self.displayDiaryContent()
                }
            }
        }
        
        task.resume()
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
        
        // 데이터가 있는지 확인
        if let diaryContent = self.diaryContent, diaryContent != "아직 일기가 없어요!" {
            // EditDiaryViewController로 이동
            let editDiaryVC = EditDiaryViewController()
            editDiaryVC.diaryContent = diaryContent
            editDiaryVC.diaryDate = diaryDate
            editDiaryVC.diaryEmoji = diaryEmoji
            
            navigationController?.pushViewController(editDiaryVC, animated: true)
        } else {
            // AddDiaryViewController로 이동
            let addDiaryVC = AddDiaryViewController()
            addDiaryVC.diaryDate = diaryDate // diaryDate 전달
            
            navigationController?.pushViewController(addDiaryVC, animated: true)
        }
    }
}
