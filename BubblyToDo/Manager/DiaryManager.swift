//
//  DiaryManager.swift
//  BubblyToDo
//
//  Created by 밀가루 on 9/17/24.
//

import Foundation

class DiaryManager {
    static let shared = DiaryManager() // 싱글톤 인스턴스

    private init() {}
    
    // MARK: - 전체 Diary 가져오기
    func fetchDiaryDates(for userEmail: String, completion: @escaping ([DiaryDTO]?, String?) -> Void) {
        guard let url = getAPIUrl(for: "diary/\(userEmail)") else {
            completion(nil, "유효한 URL이 아닙니다.") // Bool 대신 [DiaryDTO]?를 사용
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching diary dates: \(error)")
                completion(nil, "서버 오류")
                return
            }

            guard let data = data else {
                completion(nil, "데이터가 없습니다.")
                return
            }
            
            do {
                // JSON 디코딩
                let diaryDTOList = try JSONDecoder().decode([DiaryDTO].self, from: data)
                completion(diaryDTOList, nil) // 성공적으로 전체 데이터 반환
            } catch {
                print("Error decoding diary dates: \(error)")
                completion(nil, "데이터 디코딩 오류")
            }
        }

        task.resume()
    }
    
    // MARK: - 개별 Diary 가져오기
    func fetchDiaryContent(diaryId: Int64, completion: @escaping (DiaryDTO?, String?) -> Void) {
        guard let url = getAPIUrl(for: "diary/detail/\(diaryId)") else {
            completion(nil, "유효한 URL이 아닙니다.") // Bool 대신 [DiaryDTO]?를 사용
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching diary: \(error)")
                completion(nil, "서버 오류")
                return
            }
            
            guard let data = data else {
                completion(nil, "데이터가 없습니다.")
                return
            }
            
            do {
                // JSON 디코딩
                let diaryDTO = try JSONDecoder().decode(DiaryDTO.self, from: data)
                completion(diaryDTO, nil) // 성공적으로 데이터를 반환
            } catch {
                print("Error decoding diary: \(error)")
                completion(nil, "데이터 디코딩 오류") // 오류 반환
            }
        }
        
        task.resume()
    }

    // MARK: - Add Diary
    func saveDiary(diaryDTO: DiaryDTO, completion: @escaping (Bool, String?) -> Void) {
        guard let url = getAPIUrl(for: "diary/addDiary") else {
            completion(false, "유효한 URL이 아닙니다.")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            let jsonData = try JSONEncoder().encode(diaryDTO)
            request.httpBody = jsonData

            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Error adding diary: \(error)")
                    completion(false, "서버 오류")
                    return
                }

                guard let response = response as? HTTPURLResponse else {
                    print("Invalid response")
                    completion(false, "유효하지 않은 응답")
                    return
                }

                // 상태 코드 확인
                switch response.statusCode {
                case 201: // Created
                    completion(true, nil) // 성공
                case 400: // Bad Request
                    completion(false, "다이어리 저장 실패: 이미 존재하는 카테고리")
                default:
                    completion(false, "서버 오류: HTTP \(response.statusCode)")
                }
            }

            task.resume()
        } catch {
            print("Error encoding diary: \(error)")
            completion(false, "JSON 인코딩 오류")
        }
    }
    
    // MARK: - Update Diary 
    func updateDiary(diaryDTO: DiaryDTO, completion: @escaping (Bool, String?) -> Void) {
        // diaryId가 옵셔널이므로 안전하게 언래핑
        guard let diaryId = diaryDTO.diaryId else {
            print("Error: diaryId is nil")
            completion(false, "diaryId가 유효하지 않습니다.")
            return
        }
        
        guard let url = getAPIUrl(for: "diary/update/\(diaryId)") else {
            completion(false, "유효한 URL이 아닙니다.")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let jsonData = try JSONEncoder().encode(diaryDTO)
            request.httpBody = jsonData
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Error updating diary: \(error)")
                    completion(false, error.localizedDescription)
                    return
                }
                
                guard let response = response as? HTTPURLResponse else {
                    completion(false, "Invalid response")
                    return
                }
                
                if (200...299).contains(response.statusCode) {
                    completion(true, nil) // 성공적으로 업데이트됨
                } else {
                    if let data = data, let errorMessage = String(data: data, encoding: .utf8) {
                        print("Server error: \(errorMessage)")
                        completion(false, errorMessage)
                    } else {
                        completion(false, "Server error: \(response.statusCode)")
                    }
                }
            }
            
            task.resume()
        } catch {
            print("Error encoding diary: \(error)")
            completion(false, error.localizedDescription)
        }
    }
}
