//
//  LoginManager.swift
//  BubblyToDo
//
//  Created by 밀가루 on 9/16/24.
//

class LoginManager {
    static let shared = LoginManager()
    
    private init() {}
    
    func loginUser(userDTO: UserDTO, completion: @escaping (Bool, String?) -> Void) {
        let url = URL(string: "http://localhost:8084/bubbly-todo/login")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let loginData: [String: Any] = [
            "userEmail": userDTO.userEmail,
            "userpPssword": userDTO.userPassword,
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: loginData, options: [])
        } catch {
            print("Error serializing JSON: \(error)")
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error)")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                // HTTP 상태 코드 확인
                if httpResponse.statusCode == 200 {
                    // 로그인 성공
                    DispatchQueue.main.async {
                        // UserDefaults에 이메일 저장
                        UserDefaults.standard.set(userDTO.userEmail, forKey: "useremail")
                        print("userDTO.useremail 저장 성공: \(userDTO.userEmail)")
                        
                        // MainViewController로 이동
                        let mainVC = MainViewController()
                        self.navigationController?.pushViewController(mainVC, animated: true)
                    }
                } else {
                    // 로그인 실패 처리
                    if let data = data, let responseString = String(data: data, encoding: .utf8) {
                        print("로그인 실패: \(responseString)")
                    } else {
                        print("로그인 실패: 서버에서 응답이 없습니다.")
                    }
                }
            }
        }
        
        task.resume()
    }
}
