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
        
        todoTopView.leftArrowImage.addTarget(self, action: #selector(leftArrowTapped), for: .touchUpInside)
        todoTopView.rigntArrowImage.addTarget(self, action: #selector(rightArrowTapped), for: .touchUpInside)
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
        let datePickerView = DatePickerView(selectedDate: Date())
        datePickerView.backgroundColor = UIColor.black.withAlphaComponent(0.5) // 반투명 배경
        
        // DatePickerView를 TodoViewController의 뷰에 추가
        view.addSubview(datePickerView)
        
        // DatePickerView 제약 조건 설정
        datePickerView.snp.makeConstraints {
            $0.edges.equalToSuperview() // 화면 전체를 차지하도록 설정
        }
    }
    
    @objc func leftArrowTapped() {
        print("left button click")
    }
    
    @objc func rightArrowTapped() {
        print("right button click")
    }
}
