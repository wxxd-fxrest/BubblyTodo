//
//  ButtonFactory+.swift
//  BubblyToDo
//
//  Created by 밀가루 on 9/25/24.
//

import UIKit
import Then

class ButtonFactory {
//    static func longButton(title: String, titleColor: UIColor, backgroundColor: UIColor, cornerRadius: CGFloat = 0, target: Any?, action: Selector) -> UIButton {
//        return UIButton().then {
//            $0.setTitle(title, for: .normal)
//            $0.setTitleColor(titleColor, for: .normal)
//            $0.titleLabel?.font = UIFont.pretendard(style: .semiBold, size: 16, isScaled: true)
//            $0.backgroundColor = backgroundColor
//            $0.layer.cornerRadius = cornerRadius
//            $0.clipsToBounds = true
//            $0.addTarget(target, action: action, for: .touchUpInside)
//        }
//    }
    
    static func longButton(title: String, titleColor: UIColor, backgroundColor: UIColor, cornerRadius: CGFloat = 0) -> UIButton {
        return UIButton().then {
            $0.setTitle(title, for: .normal)
            $0.setTitleColor(titleColor, for: .normal)
            $0.titleLabel?.font = UIFont.pretendard(style: .semiBold, size: 16, isScaled: true)
            $0.backgroundColor = backgroundColor
            $0.layer.cornerRadius = cornerRadius
            $0.clipsToBounds = true
        }
    }
}
