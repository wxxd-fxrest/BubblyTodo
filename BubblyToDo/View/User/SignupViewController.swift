//
//  SignupViewController.swift
//  BubblyToDo
//
//  Created by 밀가루 on 9/13/24.
//

import UIKit
import Then
import SnapKit

class SignupViewController: UIViewController {
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
    
    // Text Field
    private lazy var emailTextField = StartUserFactory.userTextField(placeholder: "이메일을 입력해 주세요.", textColor: MySpecialColors.TextColor, font: UIFont.pretendard(style: .regular, size: 16, isScaled: true), backgroundColor: MySpecialColors.FieldColor, cornerRadius: 8, leftPadding: 16, rightPadding: 84)
    private lazy var userNameTextField = StartUserFactory.userTextField(placeholder: "닉네임을 입력해 주세요.", textColor: MySpecialColors.TextColor, font: UIFont.pretendard(style: .regular, size: 16, isScaled: true), backgroundColor: MySpecialColors.FieldColor, cornerRadius: 8, leftPadding: 16, rightPadding: 84)
    private lazy var passwordTextField = StartUserFactory.passwordTextField(placeholder: "비밀번호를 입력해 주세요.", textColor: MySpecialColors.TextColor, font: UIFont.pretendard(style: .regular, size: 16, isScaled: true), backgroundColor: MySpecialColors.FieldColor, cornerRadius: 8, isSecure: true, leftPadding: 16, rightPadding: 84)
    private lazy var checkPasswordTextField = StartUserFactory.passwordTextField(placeholder: "비밀번호를 확인해 주세요.", textColor: MySpecialColors.TextColor, font: UIFont.pretendard(style: .regular, size: 16, isScaled: true), backgroundColor: MySpecialColors.FieldColor, cornerRadius: 8, isSecure: true, leftPadding: 16, rightPadding: 84)
    private lazy var textFieldStackView: UIStackView = UIFactory.makeStackView(
        arrangedSubviews: [emailTextField, userNameTextField, passwordTextField, checkPasswordTextField],
        axis: .vertical,
        spacing: 16,
        alignment: .fill,
        distribution: .fillEqually
    )

    // Button
    private lazy var signupButton = ButtonFactory.longButton(title: "회원가입", titleColor: MySpecialColors.WhiteColor, backgroundColor: MySpecialColors.MainColor, cornerRadius: 8, target: self, action: #selector(signUpButtonTapped))
    private lazy var consentCheckBox = UIFactory.makeImageButton(image: UIImage(systemName: "square"), tintColor: MySpecialColors.MainColor)
    private lazy var consentText = UIFactory.makeLabel(text: "개인정보 보안 동의", textColor: MySpecialColors.TermTextColor, font: UIFont.pretendard(style: .regular, size: 12, isScaled: true))
    
    private lazy var consentStackView: UIStackView = UIFactory.makeStackView(
        arrangedSubviews: [consentCheckBox, consentText],
        axis: .horizontal,
        spacing: 8,
        alignment: .leading,
        distribution: .equalSpacing
    )
    
    private lazy var buttonStackView: UIStackView = UIFactory.makeStackView(
        arrangedSubviews: [consentStackView, signupButton],
        axis: .vertical,
        spacing: 12,
        alignment: .fill,
        distribution: .fill
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationUI()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    private func setupNavigationUI() {
        self.navigationController?.navigationBar.topItem?.title = ""
        self.navigationController?.navigationBar.tintColor = MySpecialColors.MainColor
//        navigationItem.title = "회원가입"
//        // 타이틀 색상 및 폰트 설정
//        navigationController?.navigationBar.titleTextAttributes = [
//            .foregroundColor: MySpecialColors.MainColor, // 원하는 색상으로 설정
//            .font: UIFont.pretendard(style: .semiBold, size: 18, isScaled: true) // 원하는 폰트 설정
//        ]
    }
    
    func setupUI() {
        view.backgroundColor = MySpecialColors.WhiteColor
        
        view.addSubviews(logoView, textFieldStackView, buttonStackView)
        logoView.addSubview(logoStackView)
        
        setupLogoViewUI()
        setupStackView()
    }
    
    private func setupLogoViewUI() {
        logoView.snp.makeConstraints {
            $0.top.equalTo(view.snp.top).offset(162)
            $0.leading.trailing.equalToSuperview().inset(64)
            $0.height.equalTo(80)
        }
        
        logoStackView.snp.makeConstraints {
            $0.height.equalToSuperview()
            $0.width.equalToSuperview()
        }
    }
    
    private func setupStackView() {
        // 제약 조건 설정
        textFieldStackView.snp.makeConstraints {
            $0.top.equalTo(logoView.snp.bottom).offset(50)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(240)
        }
        
        consentStackView.snp.makeConstraints {
            $0.height.equalTo(16)
        }
        
        buttonStackView.snp.makeConstraints {
            $0.bottom.equalTo(view.snp.bottom).offset(-100)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(76)
        }
    }
    
    @objc func signUpButtonTapped() {
        guard let email = emailTextField.text,
              let username = userNameTextField.text,
              let password = passwordTextField.text,
              let passwordConfirmation = checkPasswordTextField.text else { return }
        
        // 비밀번호 일치 여부 확인
        guard password == passwordConfirmation else {
            print("비밀번호가 일치하지 않습니다.")
            return
        }
        
        // User 모델 생성
        let userDTO = UserDTO(userEmail: email, userPassword: password, userName: username)
        
        print("Email: \(userDTO.userEmail), Username: \(userDTO.userName), Password: \(userDTO.userPassword)")
        
        // UserManager를 사용하여 회원가입 요청
        UserManager.shared.signUp(userDTO: userDTO) { success, errorMessage in
            if success {
                // MainViewController로 이동
                let mainVC = MainViewController()
                self.navigationController?.pushViewController(mainVC, animated: true)
            } else {
                // 회원가입 실패 처리
                if let errorMessage = errorMessage {
                    print("회원가입 실패: \(errorMessage)")
                }
            }
        }
    }

}
