//
//  SignupViewModel.swift
//  BubblyToDo
//
//  Created by 밀가루 on 9/26/24.
//

import Foundation

class SignupViewModel {
    private var email: String = ""
    private var username: String = ""
    private var password: String = ""
    private var checkPassword: String = ""
    var passwordCheck: Bool = false
    
    var isValidEmail: Bool {
        return isValidEmailFormat(email)
    }
    
    var isPasswordValid: Bool {
        return isValidPassword(password)
    }
    
    var arePasswordsMatching: Bool {
        return password == checkPassword
    }
    
    func updateEmail(_ email: String) {
        self.email = email
    }
    
    func updateUsername(_ username: String) {
        self.username = username
    }
    
    func updatePassword(_ password: String) {
        self.password = password
    }
    
    func updatePasswordConfirmation(_ checkPassword: String) {
        self.checkPassword = checkPassword
    }
    
    func signUp(completion: @escaping (Bool, String?) -> Void) {
        guard isValidEmail, isPasswordValid, arePasswordsMatching else {
            completion(false, "입력 정보를 확인해 주세요.")
            return
        }

        let userDTO = UserDTO(userEmail: email, userPassword: password, userName: username)
        
        UserManager.shared.signUp(userDTO: userDTO) { success, errorMessage in
            completion(success, errorMessage)
        }
    }
    
    func validatePassword(_ password: String) -> String? {
       if password.isEmpty {
           return "비밀번호를 입력해 주세요."
       } else if !isValidPassword(password) {
           passwordCheck = false
           return "⚠ 비밀번호는 8~16자, 대문자/숫자 각각 1개 이상 포함해야 합니다."
       }
       passwordCheck = true
       return nil
   }
    
   func checkPasswordMatch(password: String, confirmPassword: String) -> String {
       return password == confirmPassword ? "비밀번호가 일치합니다." : "⚠ 비밀번호가 일치하지 않습니다."
   }
    
    func isValidEmailFormat(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with: email)
    }

    func isValidPassword(_ password: String) -> Bool {
        let passwordRegex = "^(?=.*[A-Z])(?=.*[0-9])(?=.*[a-z]).{8,16}$"
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        return passwordTest.evaluate(with: password)
    }
}
