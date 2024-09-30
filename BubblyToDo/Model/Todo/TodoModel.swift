//
//  TodoModel.swift
//  BubblyToDo
//
//  Created by 밀가루 on 9/30/24.
//

import Foundation

struct DateModel {
    var dates: [String]
    var selectedDate: Date
    var currentYear: Int
    var currentMonth: Int
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
