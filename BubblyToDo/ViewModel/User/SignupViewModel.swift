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
    private var passwordConfirmation: String = ""
    
    var isValidEmail: Bool {
        return isValidEmailFormat(email)
    }
    
    var isPasswordValid: Bool {
        return isValidPassword(password)
    }
    
    var arePasswordsMatching: Bool {
        return password == passwordConfirmation
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
    
    func updatePasswordConfirmation(_ passwordConfirmation: String) {
        self.passwordConfirmation = passwordConfirmation
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
    
    private func isValidEmailFormat(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with: email)
    }

    private func isValidPassword(_ password: String) -> Bool {
        let passwordRegex = "^(?=.*[A-Z])(?=.*[0-9])(?=.*[a-z]).{8,16}$"
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        return passwordTest.evaluate(with: password)
    }
}
