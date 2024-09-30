//
//  User.swift
//  BubblyToDo
//
//  Created by 밀가루 on 9/13/24.
//

import Foundation

struct UserDTO: Codable {
    var id: Int64?
    var userEmail: String
    var userPassword: String
    var userName: String?
}

struct CategoryDTO: Codable {
    var categoryId: Int64?
    let category: String
    let categoryColor: String // 예를 들어, 색상을 HEX 문자열로 변환할 수도 있습니다.
    var categoryUser: String?
}

struct DiaryDTO: Codable {
    var diaryId: Int64?
    var diary: String
    var diaryDate: String
    var diaryEmoji: String
    var diaryUser: String
}
