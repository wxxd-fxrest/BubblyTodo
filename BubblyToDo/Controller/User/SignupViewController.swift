//
//  SignupViewController.swift
//  BubblyToDo
//
//  Created by 밀가루 on 9/13/24.
//
//
//import UIKit
//import Then
//import SnapKit
//
//class SignupViewController: UIViewController, UITextFieldDelegate {
//    private var passwordCheck: Bool = false
//    private var signupAlert: String = "필수 사항을 입력해 주세요."
//    private var securityCheck: Bool = false
//
//    // Logo
//    private lazy var logoView =  UIFactory.makeView(backgroundColor: .clear, cornerRadius: 0)
//    private lazy var logoText = LogoFactory.logoText(LogoInfoText: "Bubbly ToDo")
//    private lazy var logoBottomText = LogoFactory.logoBottomText(LogoInfoText: "반가워요, Bubbly입니다!")
//    private lazy var logoStackView: UIStackView = UIFactory.makeStackView(
//        arrangedSubviews: [logoText, logoBottomText],
//        axis: .vertical,
//        spacing: 14,
//        alignment: .center,
//        distribution: .fill
//    )
//    
//    // Text Field
//    private lazy var emailTextField = StartUserFactory.userTextField(placeholder: "이메일을 입력해 주세요.", textColor: MySpecialColors.TextFieldFontColor, font: UIFont.pretendard(style: .regular, size: 16, isScaled: true), backgroundColor: MySpecialColors.TextFieldColor, cornerRadius: 8, leftPadding: 16, rightPadding: 84)
//    private lazy var userNameTextField = StartUserFactory.userTextField(placeholder: "닉네임을 입력해 주세요.", textColor: MySpecialColors.TextFieldFontColor, font: UIFont.pretendard(style: .regular, size: 16, isScaled: true), backgroundColor: MySpecialColors.TextFieldColor, cornerRadius: 8, leftPadding: 16, rightPadding: 84)
//    private lazy var passwordTextField = StartUserFactory.passwordTextField(placeholder: "비밀번호를 입력해 주세요.", textColor: MySpecialColors.TextFieldFontColor, font: UIFont.pretendard(style: .regular, size: 16, isScaled: true), backgroundColor: MySpecialColors.TextFieldColor, cornerRadius: 8, isSecure: true, leftPadding: 16, rightPadding: 84)
//    private lazy var checkPasswordTextField = StartUserFactory.passwordTextField(placeholder: "비밀번호를 확인해 주세요.", textColor: MySpecialColors.TextFieldFontColor, font: UIFont.pretendard(style: .regular, size: 16, isScaled: true), backgroundColor: MySpecialColors.TextFieldColor, cornerRadius: 8, isSecure: true, leftPadding: 16, rightPadding: 84)
//    private lazy var textFieldStackView: UIStackView = UIFactory.makeStackView(
//        arrangedSubviews: [emailTextField, userNameTextField, passwordTextField, checkPasswordTextField],
//        axis: .vertical,
//        spacing: 16,
//        alignment: .fill,
//        distribution: .fillEqually
//    )
//
//    // Button
////    private lazy var signupButton = ButtonFactory.longButton(title: "회원가입", titleColor: MySpecialColors.WhiteColor, backgroundColor: MySpecialColors.MainColor, cornerRadius: 8, target: self, action: #selector(signUpButtonTapped))
//    private lazy var signupButton: UIButton = {
//        let button = ButtonFactory.longButton(
//            title: "회원가입",
//            titleColor: MySpecialColors.WhiteColor,
//            backgroundColor: MySpecialColors.MainColor,
//            cornerRadius: 8
//        )
//        button.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
//        return button
//    }()
//
//    private lazy var consentCheckBox = UIFactory.makeImageButton(image: UIImage(systemName: "square"), tintColor: MySpecialColors.MainColor)
//    private lazy var consentText = UIFactory.makeLabel(text: "개인정보 보안 동의", textColor: MySpecialColors.TermTextColor, font: UIFont.pretendard(style: .regular, size: 12, isScaled: true))
//    
//    private lazy var consentStackView: UIStackView = UIFactory.makeStackView(
//        arrangedSubviews: [consentCheckBox, consentText],
//        axis: .horizontal,
//        spacing: 8,
//        alignment: .leading,
//        distribution: .equalSpacing
//    )
//    
//    private lazy var buttonStackView: UIStackView = UIFactory.makeStackView(
//        arrangedSubviews: [consentStackView, signupButton],
//        axis: .vertical,
//        spacing: 12,
//        alignment: .fill,
//        distribution: .fill
//    )
//        
//    private lazy var alertText = UIFactory.makeLabel(text: signupAlert, textColor: MySpecialColors.MainColor, font: UIFont.pretendard(style: .regular, size: 12, isScaled: true))
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        emailTextField.delegate = self
//        passwordTextField.delegate = self
//        checkPasswordTextField.delegate = self
//        
//        emailTextField.addTarget(self, action: #selector(emailTextFieldDidChange(_:)), for: .editingChanged)
//        passwordTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
//        checkPasswordTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
//        
//        checkPasswordTextField.isHidden = true
//        
//        
//        // 스택뷰에 클릭 제스처 추가
//        let consentCheckBoxTapGesture = UITapGestureRecognizer(target: self, action: #selector(consentCheckBoxTapped))
//        consentCheckBox.addGestureRecognizer(consentCheckBoxTapGesture)
//        consentCheckBox.isUserInteractionEnabled = true // 사용자 상호작용 활성화
//
//        let consentTextTapGesture = UITapGestureRecognizer(target: self, action: #selector(consentTextTapped))
//        consentText.addGestureRecognizer(consentTextTapGesture)
//        consentText.isUserInteractionEnabled = true // 사용자 상호작용 활성화
//
//        
//        setupNavigationUI()
//        setupUI()
//    }
//
//    // 체크박스 클릭 시 호출되는 메서드
//    @objc func consentCheckBoxTapped() {
//        toggleConsentCheckBox() // 체크박스 상태 변경
//    }
//
//    // 텍스트 클릭 시 호출되는 메서드
//    @objc func consentTextTapped() {
//        navigateToNextPage() // 다른 페이지로 이동하는 메서드 호출
//    }
//
//    // 체크박스 상태 토글 메서드
//    private func toggleConsentCheckBox() {
//        consentCheckBox.isSelected.toggle() // 체크박스 선택 상태 토글
//        
//        if consentCheckBox.isSelected {
//            securityCheck = true
//            consentCheckBox.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
//            consentText.textColor = MySpecialColors.TermTextColor
//        } else {
//            securityCheck = false
//            consentCheckBox.setImage(UIImage(systemName: "square"), for: .normal)
//            consentText.textColor = MySpecialColors.MainColor
//        }
//    }
//
//    // 다른 페이지로 이동하는 메서드
//    private func navigateToNextPage() {
//        // 페이지 전환 로직을 구현
//        let securityVC = SecurityViewController() // 예시로 NextViewController를 생성
//        navigationController?.pushViewController(securityVC, animated: true)
//    }
//    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        self.navigationController?.setNavigationBarHidden(false, animated: animated)
//    }
//    
//    private func setupNavigationUI() {
//        self.navigationController?.navigationBar.topItem?.title = ""
//        self.navigationController?.navigationBar.tintColor = MySpecialColors.MainColor
//    }
//    
//    func setupUI() {
//        view.backgroundColor = MySpecialColors.WhiteColor
//        
//        view.addSubviews(logoView, textFieldStackView, buttonStackView, alertText)
//        logoView.addSubview(logoStackView)
//        
//        setupLogoViewUI()
//        setupStackView()
//    }
//    
//    private func setupLogoViewUI() {
//        logoView.snp.makeConstraints {
//            $0.top.equalTo(view.snp.top).offset(162)
//            $0.leading.trailing.equalToSuperview().inset(64)
//            $0.height.equalTo(80)
//        }
//        
//        logoStackView.snp.makeConstraints {
//            $0.height.equalToSuperview()
//            $0.width.equalToSuperview()
//        }
//    }
//    
//    private func setupStackView() {
//        // 제약 조건 설정
//        textFieldStackView.snp.makeConstraints {
//            $0.top.equalTo(logoView.snp.bottom).offset(50)
//            $0.leading.trailing.equalToSuperview().inset(24)
//            $0.height.equalTo(176)
//        }
//        
//        consentStackView.snp.makeConstraints {
//            $0.height.equalTo(16)
//        }
//        
//        consentCheckBox.snp.makeConstraints {
//            $0.height.equalTo(24)
//            $0.width.equalTo(24)
//        }
//        
//        buttonStackView.snp.makeConstraints {
//            $0.bottom.equalTo(view.snp.bottom).offset(-100)
//            $0.leading.trailing.equalToSuperview().inset(24)
//            $0.height.equalTo(76)
//        }
//        
//        alertText.snp.makeConstraints {
//            $0.top.equalTo(textFieldStackView.snp.bottom).offset(10)
//            $0.leading.trailing.equalToSuperview().inset(24)
//        }
//    }
//   
//    // 이메일 텍스트 필드 변경 감지
//    @objc func emailTextFieldDidChange(_ textField: UITextField) {
//        let email = textField.text ?? ""
//        
//        if email.isEmpty {
//            alertText.text = "이메일을 입력해 주세요."
//        } else if !isValidEmail(email) {
//            alertText.text = "⚠ 이메일 형식이 올바르지 않습니다."
//        } else {
//            alertText.text = "" // 이메일 형식이 올바르면 경고 텍스트 초기화
//        }
//    }
//
//    // 이메일 형식 유효성 검사
//    private func isValidEmail(_ email: String) -> Bool {
//        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
//        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegex)
//        return emailTest.evaluate(with: email)
//    }
//
//    // UITextFieldDelegate 메서드 - 텍스트 필드 내용 변경 시 감지
//    @objc func textFieldDidChange(_ textField: UITextField) {
//        if textField == emailTextField {
//            emailTextFieldDidChange(textField) // 이메일 텍스트 필드 변경 감지
//        } else if textField == passwordTextField {
//            let currentText = textField.text ?? ""
//            if currentText.isEmpty {
//                handleEmptyPassword()
//            } else {
//                // 비밀번호 유효성 검사
//                if isValidPassword(currentText) {
//                    passwordCheck = true
//                    checkPasswordTextField.isHidden = false
//                    alertText.text = "비밀번호를 다시 한 번 확인해 주세요."
//                    alertText.textColor = MySpecialColors.MainColor
//                    checkPasswordMatch() // 비밀번호 확인 체크
//                } else {
//                    passwordCheck = false
//                    checkPasswordTextField.isHidden = true
//                    alertText.text = "⚠ 비밀번호는 8~16자, 대문자/숫자 각각 1개 이상 포함해야 합니다."
//                    alertText.textColor = MySpecialColors.RedColor
//                }
//            }
//        } else if textField == checkPasswordTextField {
//            checkPasswordMatch() // 체크 비밀번호가 변경될 때마다 확인
//        }
//    }
//
//    // UITextFieldDelegate 메서드
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        // 현재 텍스트를 가져옵니다.
//        let currentText = textField.text ?? ""
//        guard let stringRange = Range(range, in: currentText) else { return false }
//        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
//
//        // 이메일 조건 검증
//        if textField == emailTextField {
//            // Clear 버튼 클릭 시
//            if string.isEmpty && range.length == 1 {
//                alertText.text = "이메일을 입력해 주세요."
//            } else if updatedText.isEmpty {
//                alertText.text = "이메일을 입력해 주세요."
//            } else if !isValidEmail(updatedText) {
//                alertText.text = "⚠ 이메일 형식이 올바르지 않습니다."
//                alertText.textColor = MySpecialColors.RedColor
//            } else {
//                alertText.text = "" // 이메일 형식이 올바르면 경고 텍스트 초기화
//            }
//        }
//
//        // 비밀번호 조건 검증
//        if textField == passwordTextField {
//            // Clear 버튼 클릭 시
//            if string.isEmpty && range.length == 1 {
//                handleEmptyPassword()
//            } else if updatedText.isEmpty {
//                handleEmptyPassword()
//            } else if isValidPassword(updatedText) {
//                passwordCheck = true
//                checkPasswordTextField.isHidden = false
//                alertText.text = "비밀번호를 다시 한 번 확인해 주세요."
//                alertText.textColor = MySpecialColors.MainColor
//                
//                // 비밀번호 확인 체크
//                checkPasswordMatch()
//            } else {
//                passwordCheck = false
//                checkPasswordTextField.isHidden = true
//                alertText.text = "⚠ 비밀번호는 8~16자, 대문자/숫자 각각 1개 이상 포함해야 합니다."
//                alertText.textColor = MySpecialColors.RedColor
//                checkPasswordTextField.text = ""
//            }
//            
//            updateTextFieldStackViewHeight()
//        }
//
//        return true
//    }
//
//    // UITextFieldDelegate 메서드 - 텍스트 필드에서 이동할 때 경고 텍스트 초기화
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        if textField == emailTextField || textField == passwordTextField || textField == checkPasswordTextField {
//            alertText.text = "" // 다른 텍스트 필드로 이동할 때 경고 텍스트 초기화
//        }
//    }
//
//    // 입력이 비어있을 때 처리
//    private func handleEmptyPassword() {
//        passwordCheck = false
//        checkPasswordTextField.isHidden = true
//        alertText.text = "비밀번호는 8~16자, 대문자/숫자 각각 1개 이상 포함해야 합니다."
//        alertText.textColor = MySpecialColors.MainColor
//        updateTextFieldStackViewHeight()
//    }
//
//    // 비밀번호 유효성 검사 함수
//    private func isValidPassword(_ password: String) -> Bool {
//        let passwordRegex = "^(?=.*[A-Z])(?=.*[0-9])(?=.*[a-z]).{8,16}$"
//        let passwordTest = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
//        return passwordTest.evaluate(with: password)
//    }
//
//    // 비밀번호 확인 체크
//    private func checkPasswordMatch() {
//        let password = passwordTextField.text ?? ""
//        let confirmPassword = checkPasswordTextField.text ?? ""
//
//        if password == confirmPassword {
//            // 비밀번호 일치
//            alertText.text = "비밀번호가 일치합니다."
//            alertText.textColor = MySpecialColors.MainColor
//        } else {
//            // 비밀번호 불일치
//            alertText.text = "⚠ 비밀번호가 일치하지 않습니다."
//            alertText.textColor = MySpecialColors.RedColor
//        }
//    }
//
//    // 제약 조건 업데이트 메서드
//    private func updateTextFieldStackViewHeight() {
//        textFieldStackView.snp.updateConstraints {
//            $0.height.equalTo(passwordCheck ? 240 : 176) // 새로운 높이 설정
//        }
//
//        // 애니메이션 적용
//        UIView.animate(withDuration: 0.3) {
//            self.view.layoutIfNeeded()
//        }
//    }
//
//    @objc func signUpButtonTapped() {
//        guard let email = emailTextField.text,
//              let username = userNameTextField.text,
//              let password = passwordTextField.text,
//              let passwordConfirmation = checkPasswordTextField.text,
//              securityCheck == true else { // securityCheck가 Bool 타입일 때
//            // 조건이 충족되지 않을 경우 처리
//            alertText.text = "⚠ 모든 필드를 올바르게 입력하고 동의를 확인해 주세요."
//            alertText.textColor = MySpecialColors.RedColor
//            return
//        }
//        
//        // 비밀번호 일치 여부 확인
//        guard password == passwordConfirmation else {
//            print("비밀번호가 일치하지 않습니다.")
//            return
//        }
//        
//        // User 모델 생성
//        let userDTO = UserDTO(userEmail: email, userPassword: password, userName: username)
//        
//        print("Email: \(userDTO.userEmail), Username: \(userDTO.userName), Password: \(userDTO.userPassword)")
//        
//        // UserManager를 사용하여 회원가입 요청
//        UserManager.shared.signUp(userDTO: userDTO) { success, errorMessage in
//            if success {
//                // MainViewController로 이동
//                let mainVC = MainViewController()
//                DispatchQueue.main.async {
//                    self.navigationController?.pushViewController(mainVC, animated: true)
//                }
//            } else {
//                // 회원가입 실패 처리
//                if let errorMessage = errorMessage {
//                    print("회원가입 실패: \(errorMessage)")
//                    DispatchQueue.main.async {
//                        self.showAlert(message: errorMessage) // 알림창 표시
//                        self.emailTextField.text = ""
//                        self.userNameTextField.text = ""
//                        self.passwordTextField.text = ""
//                        self.checkPasswordTextField.text = ""
//                        self.securityCheck = false
//                        self.passwordCheck = false
//                        self.handleEmptyPassword()
//                    }
//                }
//            }
//        }
//    }
//
//    // 알림창을 보여주는 메서드
//    private func showAlert(message: String) {
//        let alertController = UIAlertController(title: "회원가입 실패", message: message, preferredStyle: .alert)
//        let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
//        alertController.addAction(okAction)
//        
//        // 현재 뷰 컨트롤러에서 알림창 표시
//        self.present(alertController, animated: true, completion: nil)
//    }
//}


import UIKit
import Then
import SnapKit

class SignupViewController: UIViewController, UITextFieldDelegate {
    private var signupView = SignupView()
    private var viewModel = SignupViewModel()
    private var securityCheck: Bool = false
    private var passwordCheck: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationUI()
        setupView()
        setupBindings()
        setupKeyboardObservers()
    }
    private func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    @objc private func keyboardWillShow(notification: NSNotification) {
        // 키보드가 나타날 때 UI 조정
    }

    @objc private func keyboardWillHide(notification: NSNotification) {
        // 키보드가 사라질 때 UI 조정
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
        // ViewModel에 이메일 업데이트
        //        viewModel.updateEmail(textField.text ?? "")
        
        // textFieldDidChange를 직접 호출
        //        textFieldDidChange(textField)
        
        let email = textField.text ?? ""
        
        // 이메일 유효성 검사
        if email.isEmpty {
            signupView.alertText.text = "이메일을 입력해 주세요."
        } else if !isValidEmail(email) {
            signupView.alertText.text = "⚠ 이메일 형식이 올바르지 않습니다."
        } else {
            signupView.alertText.text = "" // 이메일 형식이 올바르면 경고 텍스트 초기화
        }
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
        navigateToNextPage() // 다른 페이지로 이동하는 메서드 호출
    }
    
    // 체크박스 상태 토글 메서드
    private func toggleConsentCheckBox() {
        signupView.consentCheckBox.isSelected.toggle() // 체크박스 선택 상태 토글
        
        if signupView.consentCheckBox.isSelected {
            securityCheck = true
            signupView.consentCheckBox.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
            signupView.consentText.textColor = MySpecialColors.TermTextColor
        } else {
            securityCheck = false
            signupView.consentCheckBox.setImage(UIImage(systemName: "square"), for: .normal)
            signupView.consentText.textColor = MySpecialColors.MainColor
        }
    }
    
    // 다른 페이지로 이동하는 메서드
    private func navigateToNextPage() {
        // 페이지 전환 로직을 구현
        let securityVC = SecurityViewController() // 예시로 NextViewController를 생성
        navigationController?.pushViewController(securityVC, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    private func setupNavigationUI() {
        self.navigationController?.navigationBar.topItem?.title = ""
        self.navigationController?.navigationBar.tintColor = MySpecialColors.MainColor
    }
    
    // 이메일 형식 유효성 검사
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with: email)
    }
    
    // UITextFieldDelegate 메서드 - 텍스트 필드 내용 변경 시 감지
    @objc func textFieldDidChange(_ textField: UITextField) {
        if textField == signupView.emailTextField {
            emailTextFieldDidChange(textField) // 이메일 텍스트 필드 변경 감지
        } else if textField == signupView.passwordTextField {
            let currentText = textField.text ?? ""
            if currentText.isEmpty {
                handleEmptyPassword()
            } else {
                // 비밀번호 유효성 검사
                if isValidPassword(currentText) {
                    passwordCheck = true
                    signupView.checkPasswordTextField.isHidden = false
                    signupView.alertText.text = "비밀번호를 다시 한 번 확인해 주세요."
                    signupView.alertText.textColor = MySpecialColors.MainColor
                    checkPasswordMatch() // 비밀번호 확인 체크
                } else {
                    passwordCheck = false
                    signupView.checkPasswordTextField.isHidden = true
                    signupView.alertText.text = "⚠ 비밀번호는 8~16자, 대문자/숫자 각각 1개 이상 포함해야 합니다."
                    signupView.alertText.textColor = MySpecialColors.RedColor
                }
            }
        } else if textField == signupView.checkPasswordTextField {
            checkPasswordMatch() // 체크 비밀번호가 변경될 때마다 확인
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
            } else if !isValidEmail(updatedText) {
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
            } else if isValidPassword(updatedText) {
                passwordCheck = true
                signupView.checkPasswordTextField.isHidden = false
                signupView.alertText.text = "비밀번호를 다시 한 번 확인해 주세요."
                signupView.alertText.textColor = MySpecialColors.MainColor
                
                // 비밀번호 확인 체크
                checkPasswordMatch()
            } else {
                passwordCheck = false
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
        passwordCheck = false
        signupView.checkPasswordTextField.isHidden = true
        signupView.alertText.text = "비밀번호는 8~16자, 대문자/숫자 각각 1개 이상 포함해야 합니다."
        signupView.alertText.textColor = MySpecialColors.MainColor
        updateTextFieldStackViewHeight()
    }
    
    // 비밀번호 유효성 검사 함수
    private func isValidPassword(_ password: String) -> Bool {
        let passwordRegex = "^(?=.*[A-Z])(?=.*[0-9])(?=.*[a-z]).{8,16}$"
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        return passwordTest.evaluate(with: password)
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
            $0.height.equalTo(passwordCheck ? 240 : 176) // 새로운 높이 설정
        }
        
        // 애니메이션 적용
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func signUpButtonTapped() {
        guard let email = signupView.emailTextField.text,
              let username = signupView.userNameTextField.text,
              let password = signupView.passwordTextField.text,
              let passwordConfirmation = signupView.checkPasswordTextField.text,
              securityCheck == true else { // securityCheck가 Bool 타입일 때
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
                    let mainVC = MainViewController()
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
                        self.securityCheck = false
                        self.passwordCheck = false
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

