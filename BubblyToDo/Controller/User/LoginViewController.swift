//
//  LoginViewController.swift
//  BubblyToDo
//
//  Created by 밀가루 on 9/13/24.
//

import UIKit
import SnapKit
import Then

class LoginViewController: UIViewController, UITextFieldDelegate {
    private var loginView = LoginView()
    private var viewModel = LoginViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationUI()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    private func setupNavigationUI() {
        self.navigationController?.navigationBar.topItem?.title = ""
        self.navigationController?.navigationBar.tintColor = MySpecialColors.MainColor
    }
    
    private func setupView() {
        view.addSubview(loginView)
        loginView.frame = view.bounds
        
        // Button에 target과 action 추가
        loginView.loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        
        loginView.emailTextField.delegate = self
        loginView.passwordTextField.delegate = self
    }
    
    @objc func loginButtonTapped() {
        guard let email = loginView.emailTextField.text,
              !email.isEmpty, // 이메일이 비어있지 않은지 확인
              let password = loginView.passwordTextField.text,
              !password.isEmpty // 비밀번호가 비어있지 않은지 확인
        else {
            loginView.alertText.text = "⚠ 모든 필드를 입력해 주세요."
            loginView.alertText.textColor = MySpecialColors.RedColor
            return
        }

        // ViewModel 업데이트
        viewModel.updateEmail(email)
        viewModel.updatePassword(password)
        
        // 로그인 요청
        viewModel.login { success, errorMessage in
            if success {
                // MainViewController로 이동
                let mainVC = todoMainViewController()
                self.navigationController?.pushViewController(mainVC, animated: true)
            } else {
                // 로그인 실패 처리
                if let errorMessage = errorMessage {
                    print("로그인 실패: \(errorMessage)")
                    DispatchQueue.main.async {
                        self.showAlert(message: errorMessage) // 알림창 표시
                        self.loginView.emailTextField.text = ""
                        self.loginView.passwordTextField.text = ""
                    }
                }
            }
        }
    }
    
    // 알림창을 보여주는 메서드
    private func showAlert(message: String) {
        let alertController = UIAlertController(title: "로그인 실패", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
        alertController.addAction(okAction)
        
        // 현재 뷰 컨트롤러에서 알림창 표시
        self.present(alertController, animated: true, completion: nil)
    }
}
