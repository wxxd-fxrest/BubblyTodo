//
//  ViewController.swift
//  BubblyToDo
//
//  Created by 밀가루 on 9/12/24.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    // Logo
    private lazy var logoView =  UIFactory.makeView(backgroundColor: .clear, cornerRadius: 0)
    private lazy var logoText = LogoFactory.logoText(LogoInfoText: "Bubbly ToDo")
    private lazy var logoBottomText = LogoFactory.logoBottomText(LogoInfoText: "반가워요, Bubbly입니다!")
    private lazy var logoStackView: UIStackView = UIFactory.makeStackView(
        arrangedSubviews: [logoText, logoBottomText],
        axis: .vertical,
        spacing: 14,
        alignment: .center,
        distribution: .fill
    )
    
    // 기본 View
    private lazy var basicsView = UIFactory.makeView(backgroundColor: .clear, cornerRadius: 0)
    
    // Button
    private lazy var signupButton = ButtonFactory.longButton(title: "회원가입", titleColor: MySpecialColors.WhiteColor, backgroundColor: MySpecialColors.MainColor, cornerRadius: 8, target: self, action: #selector(signupButtonTapped))
    private lazy var loginButton = ButtonFactory.longButton(title: "로그인", titleColor: MySpecialColors.MainColor, backgroundColor: MySpecialColors.TermMainColor, cornerRadius: 8, target: self, action: #selector(loginButtonTapped))
    
    private lazy var buttonStackView: UIStackView = UIFactory.makeStackView(
        arrangedSubviews: [signupButton, loginButton],
        axis: .vertical,
        spacing: 14,
        alignment: .fill,
        distribution: .fillEqually
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // 다른 뷰로 이동할 때 내비게이션 바를 안 보이게 하려면
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    private func setupUI() {
        view.backgroundColor = MySpecialColors.WhiteColor
        
        view.addSubviews(logoView, basicsView)
        logoView.addSubviews(logoStackView)
        basicsView.addSubviews(buttonStackView)
        
        setupLogoViewUI()
        setupButtonViewUI()
    }
    
    private func setupLogoViewUI() {
        logoView.snp.makeConstraints {
            $0.top.equalTo(view.snp.top).offset(240)
            $0.leading.trailing.equalToSuperview().inset(64)
            $0.height.equalTo(80)
        }
        
        logoStackView.snp.makeConstraints {
            $0.height.equalToSuperview()
            $0.width.equalToSuperview()
        }
    }
    
    private func setupButtonViewUI() {
        basicsView.snp.makeConstraints {
            $0.bottom.equalTo(view.snp.bottom).offset(-100)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(110)
        }
        
        buttonStackView.snp.makeConstraints {
            $0.height.equalToSuperview()
            $0.width.equalToSuperview()
        }
    }
    
    @objc private func loginButtonTapped() {
        let loginVC = LoginViewController()
        navigationController?.pushViewController(loginVC, animated: true)
    }
    
    @objc private func signupButtonTapped() {
        let signupVC = SignupViewController()
        navigationController?.pushViewController(signupVC, animated: true)
    }
}
