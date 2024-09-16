//
//  User.swift
//  BubblyToDo
//
//  Created by 밀가루 on 9/13/24.
//

import Foundation

//struct User {
//    var id: Int64?
//    var useremail: String
//    var userpassword: String
//    var username: String
//}

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

struct TodoDTO: Codable {
    var todoId: Int64?
    var todo: String
    var todoDate: String
    var todoState: Bool
    var todoUser: String
    var todoCategoryId: Int64?
    var todoCategory: String
    var todoCategoryColor: String
}

struct EditTodoDTO: Codable {
    var todo: String
    var todoDate: String
    var todoCategory: String
    var todoCategoryColor: String
}

struct DiaryDTO: Codable {
    var diaryId: Int64?
    var diary: String
    var diaryDate: String
    var diaryEmoji: String
    var diaryUser: String
}

struct TodoResponse: Codable {
    let todos: [TodoDTO]
}
