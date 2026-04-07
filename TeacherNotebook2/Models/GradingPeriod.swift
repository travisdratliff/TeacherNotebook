//
//  GradingPeriod.swift
//  TeacherNotebook2
//
//  Created by Travis Domenic Ratliff on 3/21/26.
//
import SwiftUI
import SwiftData

@Model
class GradingPeriod {
    var title: String
    var startDate: Date
    var endDate: Date
    var dateRange: ClosedRange<Date> {
        startDate...endDate
    }
    init(title: String, startDate: Date, endDate: Date) {
        self.title = title
        self.startDate = startDate
        self.endDate = endDate
    }
}
