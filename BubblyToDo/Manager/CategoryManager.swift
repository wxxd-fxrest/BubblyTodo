//
//  CategoryManager.swift
//  BubblyToDo
//
//  Created by 밀가루 on 9/17/24.
//

import Foundation

class CategoryManager {
    static let shared = CategoryManager() // 싱글톤 인스턴스

    private init() {}

    // MARK: - Load Category
    func loadCategories(for userEmail: String, completion: @escaping ([CategoryDTO]?, Error?) -> Void) {
        guard let url = getAPIUrl(for: "category/\(userEmail)") else {
            completion(nil, NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "유효한 URL이 아닙니다."]))
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching categories: \(error)")
                completion(nil, error)
                return
            }

            guard let data = data else {
                completion(nil, NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "데이터 없음"]))
                return
            }

            do {
                let categoryDTOList = try JSONDecoder().decode([CategoryDTO].self, from: data)
                print("Fetched Categories: \(categoryDTOList)") // 디버깅 출력
                completion(categoryDTOList, nil)
            } catch {
                print("Error decoding JSON: \(error)")
                completion(nil, error)
            }
        }

        task.resume()
    }
    
    // MARK: - Add Category
    func sendCategoryToServer(categoryDTO: CategoryDTO, completion: @escaping (Bool, String?) -> Void) {
        guard let url = getAPIUrl(for: "category") else {
            completion(false, "유효한 URL이 아닙니다.")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let categoryData: [String: Any] = [
            "category": categoryDTO.category,
            "categoryColor": categoryDTO.categoryColor,
            "categoryUser": categoryDTO.categoryUser
        ]
        
        // JSON 인코딩
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: categoryData, options: [])
        } catch {
            print("Error serializing JSON: \(error)")
            completion(false, "JSON 직렬화 오류")
            return
        }
        
        // URLSession을 사용하여 요청 보내기
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error sending data: \(error)")
                completion(false, "데이터 전송 오류")
                return
            }
            
            // 서버의 응답 처리
            if let httpResponse = response as? HTTPURLResponse {
                print("HTTP Status Code: \(httpResponse.statusCode)") // 상태 코드 출력
                
                if httpResponse.statusCode == 201 { // 성공적으로 생성된 경우
                    print("카테고리 저장 성공")
                    completion(true, nil)
                } else {
                    // 실패 처리
                    if let data = data, let responseString = String(data: data, encoding: .utf8) {
                        print("카테고리 저장 실패: \(responseString)") // 응답 내용 출력
                        completion(false, responseString)
                    } else {
                        completion(false, "카테고리 저장 실패")
                    }
                }
            }
        }
        
        task.resume()
    }
}
