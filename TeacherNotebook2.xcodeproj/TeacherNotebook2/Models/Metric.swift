//
//  Metric.swift
//  TeacherNotebook2
//
//  Created by Travis Domenic Ratliff on 3/28/26.
//

import SwiftUI
import SwiftData

@Model
class Metric {
    var title: String
    // add var course: Course maybe?
    init(title: String) {
        self.title = title
    }
}

@Model
class MetricEntry {
    var metric: Metric
    var student: Student
    init(metric: Metric, student: Student) {
        self.metric = metric
        self.student = student
    }
}
