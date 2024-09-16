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
    // UI 요소들
    let emailTextField = UserTextFieldFactory.createEmailTextField()
    let usernameTextField = UserTextFieldFactory.createUsernameTextField()
    let passwordTextField = UserTextFieldFactory.createPasswordTextField()
    let checkPasswordTextField = UserTextFieldFactory.createCheckPasswordTextField()
    
    let signUpButton = UIButton().then {
        $0.setTitle("회원가입", for: .normal)
        $0.backgroundColor = .systemBlue
        $0.setTitleColor(.white, for: .normal)
        $0.layer.cornerRadius = 5
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        view.backgroundColor = .white
        view.addSubviews(emailTextField, usernameTextField, passwordTextField, checkPasswordTextField, signUpButton)

        // Auto Layout 설정
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(100)
            make.leading.trailing.equalTo(view).inset(20)
            make.height.equalTo(40)
        }

        usernameTextField.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(20)
            make.leading.trailing.equalTo(view).inset(20)
            make.height.equalTo(40)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(usernameTextField.snp.bottom).offset(20)
            make.leading.trailing.equalTo(view).inset(20)
            make.height.equalTo(40)
        }
        
        checkPasswordTextField.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(20)
            make.leading.trailing.equalTo(view).inset(20)
            make.height.equalTo(40)
        }

        signUpButton.snp.makeConstraints { make in
            make.top.equalTo(checkPasswordTextField.snp.bottom).offset(30)
            make.leading.trailing.equalTo(view).inset(20)
            make.height.equalTo(50)
        }
    }
    
    @objc func signUpButtonTapped() {
        guard let email = emailTextField.text,
              let username = usernameTextField.text,
              let password = passwordTextField.text else { return }
        
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
