//
//  Models.swift
//  Gradebook2
//
//  Created by Travis Domenic Ratliff on 1/18/25.
//

import Foundation
import SwiftData
import Observation
import UserNotifications
import SwiftUI

@Model
class Student {
    var firstName: String
    var lastName: String
    var id: String
    var fullName: String {
        lastName + firstName
    }
    var gradeLevel: String
    var assignments = [Assignment]()
    var notes = [Note]()
    init(firstName: String, lastName: String, id: String, gradeLevel: String, assignments: [Assignment] = [Assignment](), notes: [Note] = [Note]()) {
        self.firstName = firstName
        self.lastName = lastName
        self.id = id
        self.gradeLevel = gradeLevel
        self.assignments = assignments
        self.notes = notes
    }
}

@Model
class Assignment {
    var title: String
    var weight: Weight
    var grade: String
    var fullName: String
    var firstName = ""
    var lastName = ""
    var dueDate = Date.now
    var r: Double {
        switch weight {
        case .Daily:
            return 0.0
        case .Quiz:
            return 1.0
        case .Project:
            return 0.5
        case .Test:
            return 1.0
        }
    }
    var g: Double {
        switch weight {
        case .Daily:
            return 0.0
        case .Quiz:
            return 0.65
        case .Project:
            return 0.0
        case .Test:
            return 0.0
        }
    }
    var b: Double {
        switch weight {
        case .Daily:
            return 1.0
        case .Quiz:
            return 0.0
        case .Project:
            return 0.5
        case .Test:
            return 0.0
        }
    }
    init(title: String, weight: Weight, grade: String, fullName: String, dueDate: Foundation.Date = Date.now) {
        self.title = title
        self.weight = weight
        self.grade = grade
        self.fullName = fullName
        self.dueDate = dueDate
    }
}

@Model
class AssignmentOriginal {
    var title: String
    var weight: Weight
    var dueDate = Date.now
    var r: Double {
        switch weight {
        case .Daily:
            return 0.0
        case .Quiz:
            return 1.0
        case .Project:
            return 0.5
        case .Test:
            return 1.0
        }
    }
    var g: Double {
        switch weight {
        case .Daily:
            return 0.0
        case .Quiz:
            return 0.65
        case .Project:
            return 0.0
        case .Test:
            return 0.0
        }
    }
    var b: Double {
        switch weight {
        case .Daily:
            return 1.0
        case .Quiz:
            return 0.0
        case .Project:
            return 0.5
        case .Test:
            return 0.0
        }
    }
    init(title: String, weight: Weight, dueDate: Foundation.Date = Date.now) {
        self.title = title
        self.weight = weight
        self.dueDate = dueDate
    }
}

@Model
class Note {
    var dateWritten = Date.now
    var content: String
    init(dateWritten: Foundation.Date = Date.now, content: String) {
        self.dateWritten = dateWritten
        self.content = content
    }
}

@Model
class Lesson {
    var title = ""
    var content: String
    var lessonDate = Date.now
    init(title: String, content: String, lessonDate: Foundation.Date = Date.now) {
        self.title = title
        self.content = content
        self.lessonDate = lessonDate
    }
}

@Model
class Class {
    var title: String
    var period: String
    var students = [Student]()
    var assignmentOriginals = [AssignmentOriginal]()
    var lessons = [Lesson]()
    var notes = [ClassNote]()
    var picked = false
    init(title: String, period: String, students: [Student] = [Student](), assignmentOriginals: [AssignmentOriginal] = [AssignmentOriginal](), lessons: [Lesson] = [Lesson](), notes: [ClassNote] = [ClassNote](), picked: Bool = false) {
        self.title = title
        self.period = period
        self.students = students
        self.assignmentOriginals = assignmentOriginals
        self.lessons = lessons
        self.notes = notes
        self.picked = picked
    }
}

@Model
class ClassNote {
    var content: String
    var dateWritten = Date.now
    init(content: String, dateWritten: Foundation.Date = Date.now) {
        self.content = content
        self.dateWritten = dateWritten
    }
}

@Model
class CalendarItem {
    var title: String
    var content: String?
    var itemDate = Date.now
    var itemEndTime = Date.now
    init(title: String, content: String? = nil, itemDate: Foundation.Date = Date.now, itemEndTime: Foundation.Date = Date.now) {
        self.title = title
        self.content = content
        self.itemDate = itemDate
        self.itemEndTime = itemEndTime
    }
}

enum Weight: String, CaseIterable, Codable {
    case Daily, Quiz, Project, Test
}

extension String {
    func trim() -> String {
        self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

extension Date {
    static var firstDayOfWeek = Calendar.current.firstWeekday
    static var capitalizedFirstLettersOfWeekdays: [String] {
        let calendar = Calendar.current

        var weekdays = calendar.shortWeekdaySymbols
        if firstDayOfWeek > 1 {
            for _ in 1..<firstDayOfWeek {
                if let first = weekdays.first {
                    weekdays.append(first)
                    weekdays.removeFirst()
                }
            }
        }
        return weekdays.map { $0.capitalized }
    }
    
    static var fullMonthNames: [String] {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        
        return (1...12).compactMap { month in
            dateFormatter.setLocalizedDateFormatFromTemplate("MMMM")
            let date = Calendar.current.date(from: DateComponents(year: 2000, month: month, day: 1))
            return date.map { dateFormatter.string(from: $0) }
        }
    }
    
    var startOfMonth: Date {
        Calendar.current.dateInterval(of: .month, for: self)!.start
    }
    
    var endOfMonth: Date {
        let lastDay = Calendar.current.dateInterval(of: .month, for: self)!.end
        return Calendar.current.date(byAdding: .day, value: -1, to: lastDay)!
    }
    
    var startOfPreviousMonth: Date {
        let dayInPreviousMonth = Calendar.current.date(byAdding: .month, value: -1, to: self)!
        return dayInPreviousMonth.startOfMonth
    }
    
    var numberOfDaysInMonth: Int {
        Calendar.current.component(.day, from: endOfMonth)
    }
    
    var firstWeekDayBeforeStart: Date {
        let startOfMonthWeekday = Calendar.current.component(.weekday, from: startOfMonth)
        var numberFromPreviousMonth = startOfMonthWeekday - Self.firstDayOfWeek
        if numberFromPreviousMonth < 0 {
            numberFromPreviousMonth += 7 // Adjust to a 0-6 range if negative
        }
        return Calendar.current.date(byAdding: .day, value: -numberFromPreviousMonth, to: startOfMonth)!
    }

    var calendarDisplayDays: [Date] {
        var days: [Date] = []
        // Start with days from the previous month to fill the grid
        let firstDisplayDay = firstWeekDayBeforeStart
        var day = firstDisplayDay
        while day < startOfMonth {
            days.append(day)
            day = Calendar.current.date(byAdding: .day, value: 1, to: day)!
        }
        // Add days of the current month
        for dayOffset in 0..<numberOfDaysInMonth {
            let newDay = Calendar.current.date(byAdding: .day, value: dayOffset, to: startOfMonth)
            days.append(newDay!)
        }
        return days
    }
    
    var yearInt: Int {
        Calendar.current.component(.year, from: self)
    }
    
    
    var monthInt: Int {
        Calendar.current.component(.month, from: self)
    }
    
    var dayInt: Int {
        Calendar.current.component(.day, from: self)
    }
    
    var startOfDay: Date {
        Calendar.current.startOfDay(for: self)
    }
    var randomDateWithinLastThreeMonths: Date {
        let threeMonthsAgo = Calendar.current.date(byAdding: .month, value: -3, to: self)!
        let randomTimeInterval = TimeInterval.random(in: 0.0..<self.timeIntervalSince(threeMonthsAgo))
        let randomDate = threeMonthsAgo.addingTimeInterval(randomTimeInterval)
        return randomDate
    }
}

struct MenuLabel: View {
    var body: some View {
        Image(systemName: "line.3.horizontal")
    }
}
