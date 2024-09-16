//
//  ViewController.swift
//  BubblyToDo
//
//  Created by 밀가루 on 9/12/24.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchUserInfo()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // 다른 뷰로 이동할 때 내비게이션 바를 안 보이게 하려면
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    private func setupUI() {
        // 로그인 버튼
        let loginButton = UIButton(type: .system)
        loginButton.setTitle("로그인", for: .normal)
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        
        // 회원가입 버튼
        let signupButton = UIButton(type: .system)
        signupButton.setTitle("회원가입", for: .normal)
        signupButton.addTarget(self, action: #selector(signupButtonTapped), for: .touchUpInside)
        signupButton.translatesAutoresizingMaskIntoConstraints = false
        
        // 뷰에 버튼 추가
        view.addSubview(loginButton)
        view.addSubview(signupButton)
        
        // 버튼 오토레이아웃 설정
        NSLayoutConstraint.activate([
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -20),
            
            signupButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signupButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 20)
        ])
    }
    
    
    func fetchUserInfo() {
        if let saveuser = UserDefaults.standard.string(forKey: "useremail") {
            print("saveuser: \(saveuser)") // 저장된 이메일 출력
            
            // 사용자 정보를 가져오기
            fetchUserByEmail(useremail: saveuser) { userDTO, error in
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                } else if let userDTO = userDTO {
                    print("User found: \(userDTO)")
                    
                    // MainViewController로 이동
                    DispatchQueue.main.async {
                        let mainVC = MainViewController()
                        self.navigationController?.pushViewController(mainVC, animated: true)
                    }
                }
            }
        } else {
            print("저장된 사용자 이메일이 없습니다.")
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
