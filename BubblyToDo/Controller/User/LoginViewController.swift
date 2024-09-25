//
//  LoginViewController.swift
//  BubblyToDo
//
//  Created by 밀가루 on 9/13/24.
//

import UIKit
import SnapKit
import Then

class LoginViewController: UIViewController {
    // UI 요소들
    let emailTextField = UserTextFieldFactory.createEmailTextField()
    let passwordTextField = UserTextFieldFactory.createPasswordTextField()
    
    let loginButton = UIButton().then {
        $0.setTitle("로그인", for: .normal)
        $0.backgroundColor = .systemBlue
        $0.setTitleColor(.white, for: .normal)
        $0.layer.cornerRadius = 5
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        
        //        navigationItem.title = "회원가입"
        //        // 타이틀 색상 및 폰트 설정
        //        navigationController?.navigationBar.titleTextAttributes = [
        //            .foregroundColor: MySpecialColors.MainColor, // 원하는 색상으로 설정
        //            .font: UIFont.pretendard(style: .semiBold, size: 18, isScaled: true) // 원하는 폰트 설정
        //        ]
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubviews(emailTextField, passwordTextField, loginButton)

        // Auto Layout 설정
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(100)
            make.leading.trailing.equalTo(view).inset(20)
            make.height.equalTo(40)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(20)
            make.leading.trailing.equalTo(view).inset(20)
            make.height.equalTo(40)
        }

        loginButton.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(30)
            make.leading.trailing.equalTo(view).inset(20)
            make.height.equalTo(50)
        }
    }
    
    @objc func loginButtonTapped() {
        guard let email = emailTextField.text,
              let password = passwordTextField.text else { return }
        
        // User 모델 생성
        let userDTO = UserDTO(userEmail: email, userPassword: password)
        
        print("Email: \(userDTO.userEmail), Password: \(userDTO.userPassword)")
        
        // UserManager를 사용하여 로그인 요청
        UserManager.shared.loginUser(userDTO: userDTO) { success, errorMessage in
            if success {
                // MainViewController로 이동
                let mainVC = MainViewController()
                self.navigationController?.pushViewController(mainVC, animated: true)
            } else {
                // 로그인 실패 처리
                if let errorMessage = errorMessage {
                    print("로그인 실패: \(errorMessage)")
                }
            }
        }
    }
}
