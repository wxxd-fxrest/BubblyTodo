//
//  LoginView.swift
//  BubblyToDo
//
//  Created by 밀가루 on 9/26/24.
//

import UIKit

class LoginView: UIView {
    // Logo
    lazy var logoView =  UIFactory.makeView(backgroundColor: .clear, cornerRadius: 0)
    lazy var logoText = LogoFactory.logoText(LogoInfoText: "Bubbly ToDo")
    lazy var logoBottomText = LogoFactory.logoBottomText(LogoInfoText: "로그인을 진행해 주세요.")
    lazy var logoStackView: UIStackView = UIFactory.makeStackView(
        arrangedSubviews: [logoText, logoBottomText],
        axis: .vertical,
        spacing: 14,
        alignment: .center,
        distribution: .fill
    )
    
    // Text Field
    lazy var emailTextField = StartUserFactory.userTextField(placeholder: "이메일을 입력해 주세요.", textColor: MySpecialColors.TextFieldFontColor, font: UIFont.pretendard(style: .regular, size: 16, isScaled: true), backgroundColor: MySpecialColors.TextFieldColor, cornerRadius: 8, leftPadding: 16, rightPadding: 84)
    lazy var passwordTextField = StartUserFactory.passwordTextField(placeholder: "비밀번호를 입력해 주세요.", textColor: MySpecialColors.TextFieldFontColor, font: UIFont.pretendard(style: .regular, size: 16, isScaled: true), backgroundColor: MySpecialColors.TextFieldColor, cornerRadius: 8, isSecure: true, leftPadding: 16, rightPadding: 84)
    lazy var textFieldStackView: UIStackView = UIFactory.makeStackView(
        arrangedSubviews: [emailTextField, passwordTextField],
        axis: .vertical,
        spacing: 16,
        alignment: .fill,
        distribution: .fillEqually
    )
    
    // Button
    let loginButton = ButtonFactory.longButton(title: "로그인", titleColor: MySpecialColors.WhiteColor, backgroundColor: MySpecialColors.MainColor, cornerRadius: 8)
    
    let alertText = UIFactory.makeLabel(text: "필수 사항을 입력해 주세요.", textColor: MySpecialColors.MainColor, font: UIFont.pretendard(style: .regular, size: 12, isScaled: true))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        backgroundColor = MySpecialColors.WhiteColor
        
        addSubviews(logoView, textFieldStackView, loginButton, alertText)
        logoView.addSubview(logoStackView)
            
        setupLogoViewUI()
        setupStackView()
    }
    
    func setupLogoViewUI() {
        logoView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(162)
            $0.leading.trailing.equalToSuperview().inset(64)
            $0.height.equalTo(80)
        }
        
        logoStackView.snp.makeConstraints {
            $0.height.equalToSuperview()
            $0.width.equalToSuperview()
        }
    }
    
    func setupStackView() {
        textFieldStackView.snp.makeConstraints {
            $0.top.equalTo(logoView.snp.bottom).offset(50)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(116)
        }
        
        alertText.snp.makeConstraints {
            $0.top.equalTo(textFieldStackView.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(24)
        }
        
        loginButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-100)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(48)
        }
    }
}
