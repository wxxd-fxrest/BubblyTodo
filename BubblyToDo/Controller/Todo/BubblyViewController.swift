//
//  BubblyViewController.swift
//  BubblyToDo
//
//  Created by 밀가루 on 9/15/24.
//

import UIKit

class BubblyViewController: UIViewController {
    
    let checkboxButton = UIButton(type: .custom)
    var isChecked = false
    let bubbleAnimationDuration: TimeInterval = 1.8 // 애니메이션 지속 시간
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupCheckbox()
    }
    
    func setupCheckbox() {
        checkboxButton.setTitle("☐", for: .normal) // 체크되지 않은 상태
        checkboxButton.setTitleColor(.black, for: .normal)
        checkboxButton.titleLabel?.font = UIFont.systemFont(ofSize: 40)
        checkboxButton.addTarget(self, action: #selector(toggleCheckbox), for: .touchUpInside)
        
        checkboxButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(checkboxButton)
        
        // 체크박스 위치 설정
        NSLayoutConstraint.activate([
            checkboxButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            checkboxButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    @objc func toggleCheckbox() {
        isChecked.toggle()
        checkboxButton.setTitle(isChecked ? "☑" : "☐", for: .normal)
        animateBubbles()
    }
    
    func animateBubbles() {
        let bubbleCount = 8 // 보일 물방울 개수
        
        for _ in 0..<bubbleCount {
            let bubble = UIView()
            bubble.backgroundColor = UIColor.blue.withAlphaComponent(0.5)
            bubble.layer.cornerRadius = 8
            bubble.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(bubble)
            
            // 랜덤한 크기 설정
            let size = CGFloat.random(in: 6...16)
            bubble.frame = CGRect(x: 0, y: 0, width: size, height: size)
            
            // 체크박스 주변에 랜덤한 위치 설정
            let offsetX = CGFloat.random(in: -20...30)
            let offsetY = CGFloat.random(in: -20...30)
            let startX = checkboxButton.frame.midX + offsetX
            let startY = checkboxButton.frame.midY + offsetY
            
            bubble.center = CGPoint(x: startX, y: startY)
            
            // 애니메이션 적용
            UIView.animate(withDuration: bubbleAnimationDuration, delay: 0, options: [.curveEaseOut], animations: {
                bubble.transform = CGAffineTransform(translationX: 0, y: -50).scaledBy(x: 0.5, y: 0.5)
                bubble.alpha = 0
            }) { _ in
                bubble.removeFromSuperview() // 애니메이션 완료 후 뷰 제거
            }
        }
    }
}
