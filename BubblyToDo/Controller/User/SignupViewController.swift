//
//  SignupViewController.swift
//  BubblyToDo
//
//  Created by 밀가루 on 9/13/24.
//

import UIKit
import Then
import SnapKit

class SignupViewController: UIViewController, UITextFieldDelegate {
    private var signupView = SignupView()
    private var viewModel = SignupViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationUI()
        setupView()
        setupBindings()
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
        view.addSubview(signupView)
        signupView.frame = view.bounds
        
        // Button에 target과 action 추가
        signupView.signupButton.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
        
        signupView.consentCheckBox.addTarget(self, action: #selector(consentCheckBoxTapped), for: .touchUpInside)
        
        // UILabel에 Tap Gesture Recognizer 추가
        signupView.consentText.isUserInteractionEnabled = true // 사용자 상호작용을 활성화
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(consentTextTapped))
        signupView.consentText.addGestureRecognizer(tapGesture)
        
        signupView.emailTextField.delegate = self
        signupView.userNameTextField.delegate = self
        signupView.passwordTextField.delegate = self
        signupView.checkPasswordTextField.delegate = self
    }
    
    private func setupBindings() {
        signupView.emailTextField.addTarget(self, action: #selector(emailTextFieldDidChange(_:)), for: .editingChanged)
        signupView.userNameTextField.addTarget(self, action: #selector(userNameTextFieldDidChange(_:)), for: .editingChanged)
        signupView.passwordTextField.addTarget(self, action: #selector(passwordTextFieldDidChange(_:)), for: .editingChanged)
        signupView.checkPasswordTextField.addTarget(self, action: #selector(checkPasswordTextFieldDidChange(_:)), for: .editingChanged)
    }
    
    @objc private func emailTextFieldDidChange(_ textField: UITextField) {
        viewModel.updateEmail(textField.text ?? "")
    }
    
    @objc private func userNameTextFieldDidChange(_ textField: UITextField) {
        viewModel.updateUsername(textField.text ?? "")
    }
    
    @objc private func passwordTextFieldDidChange(_ textField: UITextField) {
        viewModel.updatePassword(textField.text ?? "")
        textFieldDidChange(textField)
    }
    
    @objc private func checkPasswordTextFieldDidChange(_ textField: UITextField) {
        viewModel.updatePasswordConfirmation(textField.text ?? "")
        textFieldDidChange(textField)
    }
    
    // 체크박스 클릭 시 호출되는 메서드
    @objc func consentCheckBoxTapped() {
        toggleConsentCheckBox() // 체크박스 상태 변경
    }
    
    // 텍스트 클릭 시 호출되는 메서드
    @objc func consentTextTapped() {
        goSecurityPage() // 다른 페이지로 이동하는 메서드 호출
    }
    
    // 체크박스 상태 토글 메서드
    private func toggleConsentCheckBox() {
        signupView.consentCheckBox.isSelected.toggle() // 체크박스 선택 상태 토글
        
        if signupView.consentCheckBox.isSelected {
            signupView.consentCheckBox.isSelected = true
            signupView.consentCheckBox.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
            signupView.consentText.textColor = MySpecialColors.TermTextColor
        } else {
            signupView.consentCheckBox.isSelected = false
            signupView.consentCheckBox.setImage(UIImage(systemName: "square"), for: .normal)
            signupView.consentText.textColor = MySpecialColors.MainColor
        }
    }
    
    // 다른 페이지로 이동하는 메서드
    private func goSecurityPage() {
        // 페이지 전환 로직을 구현
        let securityVC = SecurityViewController() // 예시로 NextViewController를 생성
        navigationController?.pushViewController(securityVC, animated: true)
    }
    
    // UITextFieldDelegate 메서드 - 텍스트 필드 내용 변경 시 감지
    @objc func textFieldDidChange(_ textField: UITextField) {
        if textField == signupView.emailTextField {
            emailTextFieldDidChange(textField) // 이메일 텍스트 필드 변경 감지
        } else if textField == signupView.passwordTextField {
            let currentText = textField.text ?? ""
            if let errorMessage = viewModel.validatePassword(currentText) {
                signupView.alertText.text = errorMessage
                signupView.checkPasswordTextField.isHidden = !viewModel.passwordCheck
            } else {
                signupView.alertText.text = "비밀번호를 다시 한 번 확인해 주세요."
                signupView.alertText.textColor = MySpecialColors.MainColor
                signupView.checkPasswordTextField.isHidden = false
            }
        } else if textField == signupView.checkPasswordTextField {
            let password = signupView.passwordTextField.text ?? ""
            let confirmPassword = textField.text ?? ""
            signupView.alertText.text = viewModel.checkPasswordMatch(password: password, confirmPassword: confirmPassword)
        }
    }
    
    // UITextFieldDelegate 메서드
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // 현재 텍스트를 가져옵니다.
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        
        // 이메일 조건 검증
        if textField == signupView.emailTextField {
            // Clear 버튼 클릭 시
            if string.isEmpty && range.length == 1 {
                signupView.alertText.text = "이메일을 입력해 주세요."
            } else if updatedText.isEmpty {
                signupView.alertText.text = "이메일을 입력해 주세요."
            } else if !viewModel.isValidEmailFormat(updatedText) {
                signupView.alertText.text = "⚠ 이메일 형식이 올바르지 않습니다."
                signupView.alertText.textColor = MySpecialColors.RedColor
            } else {
                signupView.alertText.text = "" // 이메일 형식이 올바르면 경고 텍스트 초기화
            }
        }
        
        // 비밀번호 조건 검증
        if textField == signupView.passwordTextField {
            // Clear 버튼 클릭 시
            if string.isEmpty && range.length == 1 {
                handleEmptyPassword()
            } else if updatedText.isEmpty {
                handleEmptyPassword()
            } else if viewModel.isValidPassword(updatedText) {
                viewModel.passwordCheck = true
                signupView.checkPasswordTextField.isHidden = false
                signupView.alertText.text = "비밀번호를 다시 한 번 확인해 주세요."
                signupView.alertText.textColor = MySpecialColors.MainColor
                
                // 비밀번호 확인 체크
                checkPasswordMatch()
            } else {
                viewModel.passwordCheck = false
                signupView.checkPasswordTextField.isHidden = true
                signupView.alertText.text = "⚠ 비밀번호는 8~16자, 대문자/숫자 각각 1개 이상 포함해야 합니다."
                signupView.alertText.textColor = MySpecialColors.RedColor
                signupView.checkPasswordTextField.text = ""
            }
            
            updateTextFieldStackViewHeight()
        }
        
        return true
    }
    
    // UITextFieldDelegate 메서드 - 텍스트 필드에서 이동할 때 경고 텍스트 초기화
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == signupView.emailTextField || textField == signupView.passwordTextField || textField == signupView.checkPasswordTextField {
            signupView.alertText.text = "" // 다른 텍스트 필드로 이동할 때 경고 텍스트 초기화
        }
    }
    
    // 입력이 비어있을 때 처리
    private func handleEmptyPassword() {
        viewModel.passwordCheck = false
        signupView.checkPasswordTextField.isHidden = true
        signupView.alertText.text = "비밀번호는 8~16자, 대문자/숫자 각각 1개 이상 포함해야 합니다."
        signupView.alertText.textColor = MySpecialColors.MainColor
        updateTextFieldStackViewHeight()
    }
    
    // 비밀번호 확인 체크
    private func checkPasswordMatch() {
        let password = signupView.passwordTextField.text ?? ""
        let confirmPassword = signupView.checkPasswordTextField.text ?? ""
        
        if password == confirmPassword {
            // 비밀번호 일치
            signupView.alertText.text = "비밀번호가 일치합니다."
            signupView.alertText.textColor = MySpecialColors.MainColor
        } else {
            // 비밀번호 불일치
            signupView.alertText.text = "⚠ 비밀번호가 일치하지 않습니다."
            signupView.alertText.textColor = MySpecialColors.RedColor
        }
    }
    
    // 제약 조건 업데이트 메서드
    private func updateTextFieldStackViewHeight() {
        signupView.textFieldStackView.snp.updateConstraints {
            $0.height.equalTo(viewModel.passwordCheck ? 240 : 176) // 새로운 높이 설정
        }
        
        // 애니메이션 적용
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func signUpButtonTapped() {
        guard let email = signupView.emailTextField.text, !email.isEmpty,
              let username = signupView.userNameTextField.text, !username.isEmpty,
              let password = signupView.passwordTextField.text, !password.isEmpty,
              let passwordConfirmation = signupView.checkPasswordTextField.text, !passwordConfirmation.isEmpty,
              signupView.consentCheckBox.isSelected else { // 체크박스가 선택되었는지 확인
            // 조건이 충족되지 않을 경우 처리
            signupView.alertText.text = "⚠ 모든 필드를 올바르게 입력하고 동의를 확인해 주세요."
            signupView.alertText.textColor = MySpecialColors.RedColor
            return
        }

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
                DispatchQueue.main.async {
                    let mainVC = todoMainViewController()
                    self.navigationController?.pushViewController(mainVC, animated: true)
                }
            } else {
                // 회원가입 실패 처리
                if let errorMessage = errorMessage {
                    print("회원가입 실패: \(errorMessage)")
                    DispatchQueue.main.async {
                        self.showAlert(message: errorMessage) // 알림창 표시
                        self.signupView.emailTextField.text = ""
                        self.signupView.userNameTextField.text = ""
                        self.signupView.passwordTextField.text = ""
                        self.signupView.checkPasswordTextField.text = ""
                        self.viewModel.passwordCheck = false
                        self.toggleConsentCheckBox()
                        self.handleEmptyPassword()
                    }
                }
            }
        }
    }
    
    // 알림창을 보여주는 메서드
    private func showAlert(message: String) {
        let alertController = UIAlertController(title: "회원가입 실패", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
        alertController.addAction(okAction)
        
        // 현재 뷰 컨트롤러에서 알림창 표시
        self.present(alertController, animated: true, completion: nil)
    }
}
