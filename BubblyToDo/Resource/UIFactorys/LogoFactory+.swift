//
//  LogoFactory+.swift
//  BubblyToDo
//
//  Created by 밀가루 on 9/25/24.
//

import UIKit
import Then

class LogoFactory {
    static func logoText(LogoInfoText: String) -> UILabel {
        return UILabel().then {
            $0.text = LogoInfoText
            $0.textColor = MySpecialColors.MainColor
            $0.font = UIFont.pretendard(style: .bold, size: 42, isScaled: true)
        }
    }
    
    static func logoBottomText(LogoInfoText: String) -> UILabel {
        return UILabel().then {
            $0.text = LogoInfoText
            $0.textColor = MySpecialColors.TermTextColor
            $0.font = UIFont.pretendard(style: .regular, size: 14, isScaled: true)
        }
    }
}
