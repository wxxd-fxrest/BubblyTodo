//
//  TodoTobView.swift
//  BubblyToDo
//
//  Created by 밀가루 on 9/27/24.
//

import UIKit
import SnapKit

class TodoTopView: UIView {
    // MARK: Date View
    lazy var dateStackView: UIStackView = UIFactory.makeStackView(
        arrangedSubviews: [mainDateText, dateSelectStackView],
        axis: .horizontal,
        spacing: 14,
        alignment: .fill,
        distribution: .fill
    )
    let mainDateText = UIFactory.makeLabel(text: "Today", textColor: MySpecialColors.TextColor, font: UIFont.pretendard(style: .bold, size: 18, isScaled: true))
    
    lazy var dateSelectStackView: UIStackView = UIFactory.makeStackView(
        arrangedSubviews: [dateImage, dateText],
        axis: .horizontal,
        spacing: 4,
        alignment: .center,
        distribution: .fill
    )
    let dateImage = UIFactory.makeImageView(systemName: "calendar", contentMode: .scaleAspectFit, color: MySpecialColors.MainColor)
    let dateText = UIFactory.makeLabel(text: "2024.09.33", textColor: MySpecialColors.MainColor, font: UIFont.pretendard(style: .semiBold, size: 16, isScaled: true))
    
    // MARK: Progress Bar
    lazy var progressView =  UIFactory.makeView(backgroundColor: MySpecialColors.TermMainColor, cornerRadius: 8)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
//        backgroundColor = MySpecialColors.TermTextColor.withAlphaComponent(0.3)
        
        addSubviews(dateStackView, progressView)
        
        dateStackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(24)
        }
        
        dateImage.snp.makeConstraints {
            $0.height.equalTo(24)
            $0.width.equalTo(24)
        }
    }
}
