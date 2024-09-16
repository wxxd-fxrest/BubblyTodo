//
//  LoginStateChecker.swift
//  BubblyToDo
//
//  Created by 밀가루 on 9/13/24.
//

import Foundation

// 사용자 이메일을 기반으로 회원 정보를 조회하는 함수
func fetchUserByEmail(useremail: String, completion: @escaping (UserDTO?, Error?) -> Void) {
    let urlString = "http://localhost:8084/\(useremail)"
    guard let url = URL(string: urlString) else {
        completion(nil, NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
        return
    }

    var request = URLRequest(url: url)
    request.httpMethod = "GET"

    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
            completion(nil, error)
            return
        }

        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
            if let data = data {
                do {
                    let userDTO = try JSONDecoder().decode(UserDTO.self, from: data)
                    completion(userDTO, nil)
                } catch {
                    completion(nil, error)
                }
            } else {
                completion(nil, NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data"]))
            }
        } else {
            completion(nil, NSError(domain: "", code: (response as? HTTPURLResponse)?.statusCode ?? -1, userInfo: [NSLocalizedDescriptionKey: "Request failed"]))
        }
    }

    task.resume()
}
