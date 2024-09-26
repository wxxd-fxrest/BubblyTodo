//
//  LoginViewModel.swift
//  BubblyToDo
//
//  Created by 밀가루 on 9/26/24.
//

import Foundation

class LoginViewModel {
    private var email: String = ""
    private var password: String = ""
    
    func updateEmail(_ email: String) {
        self.email = email
    }
    
    func updatePassword(_ password: String) {
        self.password = password
    }
    
    func login(completion: @escaping (Bool, String?) -> Void) {
        let userDTO = UserDTO(userEmail: email, userPassword: password)
        
        UserManager.shared.loginUser(userDTO: userDTO) { success, errorMessage in
            completion(success, errorMessage)
        }
    }
}
