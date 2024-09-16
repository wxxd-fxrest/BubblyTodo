//
//  SignupManager.swift
//  BubblyToDo
//
//  Created by 밀가루 on 9/16/24.
//

import Foundation

class UserManager {
    static let shared = UserManager() // 싱글턴 패턴

    private init() {}

    // MARK: - 회원가입 메서드
    func signUp(userDTO: UserDTO, completion: @escaping (Bool, String?) -> Void) {
        guard let url = getAPIUrl(for: "signup") else {
            completion(false, "URL을 읽을 수 없습니다.")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let signUpData: [String: Any] = [
            "userEmail": userDTO.userEmail,
            "userPassword": userDTO.userPassword,
            "userName": userDTO.userName
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: signUpData, options: [])
        } catch {
            print("Error serializing JSON: \(error)")
            completion(false, "JSON serialization error")
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error)")
                completion(false, error.localizedDescription)
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("HTTP Status Code: \(httpResponse.statusCode)")
                
                if httpResponse.statusCode == 201 {
                    DispatchQueue.main.async {
                        UserDefaults.standard.set(userDTO.userEmail, forKey: "useremail")
                        print("userDTO.useremail 저장 성공: \(userDTO.userEmail)")
                        completion(true, nil)
                    }
                } else {
                    if let data = data, let responseString = String(data: data, encoding: .utf8) {
                        print("회원가입 실패: \(responseString)")
                        completion(false, responseString)
                    } else {
                        completion(false, "서버에서 응답이 없습니다.")
                    }
                }
            }
        }
        
        task.resume()
    }

    // MARK: - 로그인 메서드 추가
    func loginUser(userDTO: UserDTO, completion: @escaping (Bool, String?) -> Void) {
        guard let url = getAPIUrl(for: "login") else {
            completion(false, "URL을 읽을 수 없습니다.")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let loginData: [String: Any] = [
            "userEmail": userDTO.userEmail,
            "userPassword": userDTO.userPassword, // 키 이름 수정
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: loginData, options: [])
        } catch {
            print("Error serializing JSON: \(error)")
            completion(false, "JSON serialization error")
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error)")
                completion(false, error.localizedDescription)
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("HTTP Status Code: \(httpResponse.statusCode)")
                
                if httpResponse.statusCode == 200 { // 로그인 성공
                    DispatchQueue.main.async {
                        UserDefaults.standard.set(userDTO.userEmail, forKey: "useremail")
                        print("userDTO.useremail 저장 성공: \(userDTO.userEmail)")
                        completion(true, nil)
                    }
                } else {
                    if let data = data, let responseString = String(data: data, encoding: .utf8) {
                        print("로그인 실패: \(responseString)")
                        completion(false, responseString)
                    } else {
                        completion(false, "서버에서 응답이 없습니다.")
                    }
                }
            }
        }
        
        task.resume()
    }
}
