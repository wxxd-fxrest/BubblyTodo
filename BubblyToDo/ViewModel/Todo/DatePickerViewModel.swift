//
//  DatePickerViewModel.swift
//  BubblyToDo
//
//  Created by 밀가루 on 9/30/24.
//

import Foundation

class DatePickerViewModel {
    private let calendar = Calendar.current
    private(set) var dateModel: DateModel
    
    init(selectedDate: Date) {
        self.dateModel = DateModel(dates: [], selectedDate: selectedDate,
                                   currentYear: calendar.component(.year, from: selectedDate),
                                   currentMonth: calendar.component(.month, from: selectedDate))
        loadDates()
    }
    
    func loadDates() {
        dateModel.dates = datesForMonth(year: dateModel.currentYear, month: dateModel.currentMonth)
    }
    
    private func datesForMonth(year: Int, month: Int) -> [String] {
        var dates: [String] = []
        var dateComponents = DateComponents(year: year, month: month)
        
        guard let firstDate = calendar.date(from: dateComponents) else { return [] }
        
        let range = calendar.range(of: .day, in: .month, for: firstDate)!
        let firstWeekday = calendar.component(.weekday, from: firstDate)
        
        for _ in 1..<firstWeekday {
            dates.append("")
        }
        
        for day in 1...range.count {
            dates.append("\(day)")
        }
        
        return dates
    }
    
    func previousMonth() {
        if dateModel.currentMonth == 1 {
            dateModel.currentMonth = 12
            dateModel.currentYear -= 1
        } else {
            dateModel.currentMonth -= 1
        }
        loadDates()
    }
    
    func nextMonth() {
        if dateModel.currentMonth == 12 {
            dateModel.currentMonth = 1
            dateModel.currentYear += 1
        } else {
            dateModel.currentMonth += 1
        }
        loadDates()
    }
}
