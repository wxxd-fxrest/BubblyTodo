//
//  TodoViewController.swift
//  BubblyToDo
//
//  Created by 밀가루 on 9/27/24.
//

import UIKit
import SnapKit

class TodoViewController: UIViewController {
    private var todoTopView = TodoTopView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = MySpecialColors.WhiteColor
        setupTodoTopUI()
        setupView()
    }
    
    private func setupView() {
        // UILabel에 Tap Gesture Recognizer 추가
        todoTopView.dateStackView.isUserInteractionEnabled = true // 사용자 상호작용을 활성화
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dateSelectTapped))
        todoTopView.dateStackView.addGestureRecognizer(tapGesture)
    }
    
    private func setupTodoTopUI() {
        // todoTopView를 부모 뷰에 추가
        view.addSubview(todoTopView)
        
        // 제약 조건 설정
        todoTopView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(260)
        }
    }
    
    @objc func dateSelectTapped() {
        print("stack click")
    }
}
