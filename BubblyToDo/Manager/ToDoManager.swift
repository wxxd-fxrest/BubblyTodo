//
//  CategoryManager.swift
//  BubblyToDo
//
//  Created by 밀가루 on 9/17/24.
//

import Foundation

class TodoManager {
    static let shared = TodoManager() // 싱글톤 인스턴스

    private init() {}
    // MARK: - ToDo List
    func loadCategories(for userEmail: String, completion: @escaping ([TodoDTO]?, Error?) -> Void) {
        guard let url = getAPIUrl(for: "list/\(userEmail)") else {
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
                let todoDTOList = try JSONDecoder().decode([TodoDTO].self, from: data)
                print("Fetched ToDos: \(todoDTOList)") // 디버깅 출력
                completion(todoDTOList, nil)
            } catch {
                print("Error decoding JSON: \(error)")
                completion(nil, error)
            }
        }
        
        task.resume()
    }
    
    // MARK: - Add ToDo
    func sendTodoToServer(todoDTO: TodoDTO, completion: @escaping (Bool, String?) -> Void) {
        guard let url = getAPIUrl(for: "addTodo") else {
            completion(false, "유효한 URL이 아닙니다.")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // JSON 데이터 구성
        let todoData: [String: Any] = [
            "todo": todoDTO.todo,
            "todoDate": todoDTO.todoDate, // LocalDate는 문자열로 변환
            "todoState": todoDTO.todoState,
            "todoUser": todoDTO.todoUser, // 사용자 이메일
            "todoCategoryId": todoDTO.todoCategoryId,
            "todoCategory": todoDTO.todoCategory, // 카테고리 이름
            "todoCategoryColor": todoDTO.todoCategoryColor // 카테고리 색상
        ]
        
        // JSON 인코딩
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: todoData, options: [])
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
                    completion(true, "ToDo 저장 성공")
                } else {
                    // 실패 처리
                    if let data = data, let responseString = String(data: data, encoding: .utf8) {
                        print("ToDo 저장 실패: \(responseString)") // 응답 내용 출력
                        completion(false, responseString)
                    } else {
                        completion(false, "ToDo 저장 실패")
                    }
                }
            }
        }
        
        task.resume()
    }
    
    // MARK: - Edit ToDo
    func updateTodoOnServer(todoId: Int64, todo: EditTodoDTO, completion: @escaping (Bool, String?) -> Void) {        
        guard let url = getAPIUrl(for: "update/\(todoId)") else {
            completion(false, "유효한 URL이 아닙니다.")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST" // POST 요청
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let encoder = JSONEncoder()
        do {
            let jsonData = try encoder.encode(todo) // EditTodoDTO를 JSON으로 인코딩
            print("Sending JSON: \(String(data: jsonData, encoding: .utf8) ?? "")") // 디버깅
            request.httpBody = jsonData
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Error updating todo: \(error)")
                    completion(false, "업데이트 실패: \(error.localizedDescription)")
                    return
                }

                if let httpResponse = response as? HTTPURLResponse {
                    print("Response status code: \(httpResponse.statusCode)") // 응답 상태 코드 확인
                    if httpResponse.statusCode == 200, let data = data,
                       let message = String(data: data, encoding: .utf8) {
                        // 성공 메시지를 반환
                        completion(true, message)
                    } else {
                        // 실패 메시지를 반환
                        let errorMessage = String(data: data ?? Data(), encoding: .utf8) ?? "업데이트할 수 없습니다."
                        completion(false, errorMessage)
                    }
                }
            }
            
            task.resume()
        } catch {
            print("Error encoding todo: \(error)")
            completion(false, "업데이트 실패: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Delete ToDo
    func deleteTodoFromServer(todoId: Int64, completion: @escaping (Bool) -> Void) {
        guard let url = getAPIUrl(for: "delete/\(todoId)") else {
            completion(false)
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "DELETE" // DELETE 요청으로 변경
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error deleting todo: \(error)")
                completion(false)
                return
            }
            
            // 응답 상태 코드 확인
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                // 성공적으로 삭제된 경우
                completion(true)
            } else {
                // 삭제 실패 처리
                completion(false)
            }
        }
        
        task.resume()
    }
}
