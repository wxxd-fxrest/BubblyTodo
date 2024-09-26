//
//  MainTabView.swift
//  BubblyToDo
//
//  Created by 밀가루 on 9/26/24.
//

//import UIKit
//import SnapKit
//
//class MainTabView: UIView {
//    lazy var tabView = UIFactory.makeView(backgroundColor: .green, cornerRadius: 0)
//    lazy var firstTab = UIFactory.makeView(backgroundColor: .orange, cornerRadius: 0)
//    lazy var firstText = UIFactory.makeLabel(text: "01", textColor: MySpecialColors.MainColor, font: UIFont.pretendard(style: .regular, size: 12, isScaled: true))
//    lazy var secondTab = UIFactory.makeView(backgroundColor: .blue, cornerRadius: 0)
//    lazy var secondText = UIFactory.makeLabel(text: "02", textColor: MySpecialColors.MainColor, font: UIFont.pretendard(style: .regular, size: 12, isScaled: true))
//    lazy var thirdTab = UIFactory.makeView(backgroundColor: .yellow, cornerRadius: 0)
//    lazy var thirdText = UIFactory.makeLabel(text: "03", textColor: MySpecialColors.MainColor, font: UIFont.pretendard(style: .regular, size: 12, isScaled: true))
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setupUI()
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    func setupUI() {
//        addSubviews(tabView)
//        tabView.addSubviews(firstTab, secondTab, thirdTab)
//        firstTab.addSubview(firstText)
//        secondTab.addSubview(secondText)
//        thirdTab.addSubview(thirdText)
//
//        // tabView 제약조건 설정
//        tabView.snp.makeConstraints {
//            $0.top.equalToSuperview().offset(0) // 네비게이션 바 바로 아래에 위치
//            $0.leading.trailing.equalToSuperview().inset(0)
//            $0.height.equalTo(40)
//        }
//
//        // 첫 번째 탭 제약조건 설정
//        firstTab.snp.makeConstraints {
//            $0.top.bottom.equalToSuperview().offset(0)
//            $0.leading.equalToSuperview().inset(0)
//            $0.width.equalToSuperview().dividedBy(3) // 화면 넓이의 1/3
//        }
//
//        // 두 번째 탭 제약조건 설정
//        secondTab.snp.makeConstraints {
//            $0.top.bottom.equalToSuperview().offset(0)
//            $0.leading.equalTo(firstTab.snp.trailing).inset(0)
//            $0.width.equalToSuperview().dividedBy(3) // 화면 넓이의 1/3
//        }
//
//        // 세 번째 탭 제약조건 설정
//        thirdTab.snp.makeConstraints {
//            $0.top.bottom.equalToSuperview().offset(0)
//            $0.leading.equalTo(secondTab.snp.trailing).inset(0)
//            $0.width.equalToSuperview().dividedBy(3) // 화면 넓이의 1/3
//        }
//
//        // 텍스트 제약조건 설정 (중앙 정렬)
//        firstText.snp.makeConstraints {
//            $0.center.equalTo(firstTab)
//        }
//
//        secondText.snp.makeConstraints {
//            $0.center.equalTo(secondTab)
//        }
//
//        thirdText.snp.makeConstraints {
//            $0.center.equalTo(thirdTab)
//        }
//    }
//}

import UIKit
import SnapKit

class MainTabView: UIView {
    lazy var firstTab = UIFactory.makeView(backgroundColor: .clear, cornerRadius: 0)
    lazy var firstText = UIFactory.makeLabel(text: "Diary", textColor: MySpecialColors.MainColor.withAlphaComponent(0.7), font: UIFont.pretendard(style: .semiBold, size: 14, isScaled: true)) // 초기 색상 빨간색
    lazy var secondTab = UIFactory.makeView(backgroundColor: .clear, cornerRadius: 0)
    lazy var secondText = UIFactory.makeLabel(text: "ToDo", textColor: MySpecialColors.MainColor, font: UIFont.pretendard(style: .semiBold, size: 14, isScaled: true))
    lazy var thirdTab = UIFactory.makeView(backgroundColor: .clear, cornerRadius: 0)
    lazy var thirdText = UIFactory.makeLabel(text: "Profile", textColor: MySpecialColors.MainColor.withAlphaComponent(0.7), font: UIFont.pretendard(style: .semiBold, size: 14, isScaled: true))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        addSubviews(firstTab, secondTab, thirdTab)
        
        firstTab.addSubview(firstText)
        secondTab.addSubview(secondText)
        thirdTab.addSubview(thirdText)
        
        // 탭 제약조건 설정
        firstTab.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.width.equalToSuperview().dividedBy(3) // 화면 넓이의 1/3
        }
        
        secondTab.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.equalTo(firstTab.snp.trailing)
            $0.width.equalToSuperview().dividedBy(3)
        }
        
        thirdTab.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.equalTo(secondTab.snp.trailing)
            $0.width.equalToSuperview().dividedBy(3)
        }
        
        // 텍스트 중앙 정렬
        firstText.snp.makeConstraints { $0.center.equalTo(firstTab) }
        secondText.snp.makeConstraints { $0.center.equalTo(secondTab) }
        thirdText.snp.makeConstraints { $0.center.equalTo(thirdTab) }
        
        // 탭 클릭 제스처 추가
        firstTab.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tabTapped(_:))))
        secondTab.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tabTapped(_:))))
        thirdTab.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tabTapped(_:))))
    }
    
    @objc private func tabTapped(_ sender: UITapGestureRecognizer) {
        guard let tappedTab = sender.view else { return }
        
        // 모든 탭의 텍스트 색상을 초기화
        resetTabTextColors()
        
        // 클릭된 탭의 텍스트 색상을 빨간색으로 변경
        if tappedTab == firstTab {
            firstText.textColor = MySpecialColors.MainColor
            firstText.font = UIFont.pretendard(style: .bold, size: 14, isScaled: true)
        } else if tappedTab == secondTab {
            secondText.textColor = MySpecialColors.MainColor
            secondText.font = UIFont.pretendard(style: .bold, size: 14, isScaled: true)
        } else if tappedTab == thirdTab {
            thirdText.textColor = MySpecialColors.MainColor
            thirdText.font = UIFont.pretendard(style: .bold, size: 14, isScaled: true)
        }
        
        // 탭 클릭 이벤트 알림
        NotificationCenter.default.post(name: NSNotification.Name("TabTapped"), object: tappedTab)
    }
    
    func resetTabTextColors() {
        firstText.textColor = MySpecialColors.MainColor.withAlphaComponent(0.7)
        firstText.font = UIFont.pretendard(style: .semiBold, size: 14, isScaled: true)

        secondText.textColor = MySpecialColors.MainColor.withAlphaComponent(0.7)
        secondText.font = UIFont.pretendard(style: .semiBold, size: 14, isScaled: true)
        
        thirdText.textColor = MySpecialColors.MainColor.withAlphaComponent(0.7)
        thirdText.font = UIFont.pretendard(style: .semiBold, size: 14, isScaled: true)
    }
}
