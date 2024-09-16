//
//  LoginStateChecker.swift
//  BubblyToDo
//
//  Created by 밀가루 on 9/13/24.
//

import Foundation

// 사용자 이메일을 기반으로 회원 정보를 조회하는 함수
func fetchUserByEmail(useremail: String, completion: @escaping (UserDTO?, Error?) -> Void) {
    guard let url = getAPIUrl(for: "\(useremail)") else {
        let error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "URL을 읽을 수 없습니다."])
        completion(nil, error)
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
                    completion(nil, error) // JSON 디코딩 에러 전달
                }
            } else {
                // 데이터가 없는 경우
                let error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data"])
                completion(nil, error)
            }
        } else {
            // 요청 실패
            let error = NSError(domain: "", code: (response as? HTTPURLResponse)?.statusCode ?? -1, userInfo: [NSLocalizedDescriptionKey: "Request failed"])
            completion(nil, error)
        }
    }

    task.resume()
}
