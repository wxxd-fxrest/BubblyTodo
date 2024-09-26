//
//  UIColor.swift
//  BubblyToDo
//
//  Created by 밀가루 on 9/16/24.
//

import Foundation
import UIKit

extension UIColor {

    convenience init(hex: String) {

        var hex = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if hex.hasPrefix("#") {
            hex.remove(at: hex.startIndex)
        }

        guard hex.count == 6 else {
            self.init(cgColor: UIColor.gray.cgColor)
            return
        }

        var rgbValue: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&rgbValue)

        self.init(
            red:   CGFloat((rgbValue & 0xFF0000) >> 16) / 255,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255,
            blue:  CGFloat(rgbValue & 0x0000FF) / 255,
            alpha: 1
        )
    }
}

enum MySpecialColors {
    //hex code
    static let MainColor = UIColor(hex: "#4C73C2")
    static let TermMainColor = UIColor(hex: "#CCDDF1")
    static let TermTextColor = UIColor(hex: "#91929F")
//    static let TextColor = UIColor(hex: "#4C4C57")3D3D3D
    static let TextColor = UIColor(hex: "#3D3D3D")
    static let TextFieldFontColor = UIColor(hex: "#7E7F8A")
    static let WhiteColor = UIColor(hex: "#FCFCFC")
    static let TextFieldColor = UIColor(hex: "#F0F5FF")
    static let RedColor = UIColor(hex: "#FC2119")

    //color asset
    static let customColor  = UIColor(named: "")
}

