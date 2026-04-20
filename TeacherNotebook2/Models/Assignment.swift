//
//  Assignment.swift
//  TeacherNotebook2
//
//  Created by Travis Domenic Ratliff on 3/21/26.
//

import SwiftUI
import SwiftData

@Model
class Assignment {
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    var id = UUID()
    var courseTitle: String
    var title: String
    var weight: GradingWeight?
    var metric: Metric?
    var assignedDate: Date
    var dueDate: Date
    @Relationship(deleteRule: .cascade) var grades: [Grade]
    var classAverage: Double {
        guard !grades.isEmpty else { return 0.0 }
        var total = 0.0
        for grade in grades {
            total += grade.score ?? 0.0
        }
        return total / Double(grades.count)
    }
    var dueDateString: String {
        dueDate.formatted(.dateTime.year().month().day())
    }
    init(id: UUID = UUID(), courseTitle: String, title: String, weight: GradingWeight? = nil, metric: Metric? = nil, assignedDate: Date, dueDate: Date, grades: [Grade]) {
        self.id = id
        self.courseTitle = courseTitle
        self.title = title
        self.weight = weight
        self.metric = metric
        self.assignedDate = assignedDate
        self.dueDate = dueDate
        self.grades = grades
    }
}
