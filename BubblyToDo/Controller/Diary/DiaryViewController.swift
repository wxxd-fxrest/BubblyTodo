//
//  DiaryViewController.swift
//  BubblyToDo
//
//  Created by 밀가루 on 9/27/24.
//

import UIKit

class DiaryViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = MySpecialColors.WhiteColor
        
        // 중앙에 텍스트 레이블 추가
        let label = UILabel()
        label.text = "First View"
        label.textColor = MySpecialColors.MainColor
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textAlignment = .center
        view.addSubview(label)
        
        // 중앙 정렬 제약 조건 설정
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
