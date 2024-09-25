//
//  UIFactory+.swift
//  BubblyToDo
//
//  Created by 밀가루 on 9/25/24.
//

import UIKit
import Then

class UIFactory: UIViewController {
    static func makeView(backgroundColor: UIColor, cornerRadius: CGFloat = 0) -> UIView {
        return UIView().then {
            $0.backgroundColor = backgroundColor
            $0.layer.cornerRadius = cornerRadius
            $0.clipsToBounds = true
        }
    }
    
    static func makeStackView(arrangedSubviews: [UIView], axis: NSLayoutConstraint.Axis, spacing: CGFloat, alignment: UIStackView.Alignment, distribution: UIStackView.Distribution) -> UIStackView {
        return UIStackView(arrangedSubviews: arrangedSubviews).then {
            $0.axis = axis
            $0.spacing = spacing
            $0.alignment = alignment
            $0.distribution = distribution
        }
    }
    
    static func makeLabel(text: String, textColor: UIColor, font: UIFont, textAlignment: NSTextAlignment = .left) -> UILabel {
        return UILabel().then {
            $0.text = text
            $0.textColor = textColor
            $0.font = font
            $0.textAlignment = textAlignment
        }
    }
    
    static func makeButton(title: String, titleColor: UIColor, font: UIFont, backgroundColor: UIColor, cornerRadius: CGFloat = 0, image: UIImage?) -> UIButton {
        return UIButton().then {
            $0.setTitle(title, for: .normal)
            $0.setTitleColor(titleColor, for: .normal)
            if let image = image {
                $0.setImage(image, for: .normal)
            }
            $0.titleLabel?.font = font
            $0.backgroundColor = backgroundColor
            $0.layer.cornerRadius = cornerRadius
            $0.clipsToBounds = true
        }
    }
    
    static func makeImageButton(image: UIImage?, tintColor: UIColor) -> UIButton {
        return UIButton().then {
            if let image = image {
                $0.setImage(image, for: .normal)
            }
            $0.tintColor = tintColor
        }
    }
}
