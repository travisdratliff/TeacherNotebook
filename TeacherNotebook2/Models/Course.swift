//
//  Course.swift
//  TeacherNotebook2
//
//  Created by Travis Domenic Ratliff on 3/21/26.
//
import SwiftUI
import SwiftData

@Model
class Course {
    var id = UUID()
    var title: String
    var period: Int
    @Relationship(deleteRule: .cascade) var metrics: [Metric] = []
    @Relationship(deleteRule: .cascade) var students: [Student] = []
    @Relationship(deleteRule: .cascade) var assignments: [Assignment] = []
    @Relationship(deleteRule: .cascade) var seats: [Seat] = []
    @Relationship(deleteRule: .cascade) var desk = Desk(x: 0.0, y: 0.0)
    @Relationship(deleteRule: .cascade) var notes: [Note] = []
    @Relationship(deleteRule: .cascade) var lessons: [Lesson] = []
    @Relationship(deleteRule: .cascade) var templates: [LessonTemplate] = []
<<<<<<< HEAD
    var passingGrade = 0.0
=======
>>>>>>> bff29d8bf5549a352338a6adbb20613857e27695
    init(id: UUID = UUID(), title: String, period: Int, metrics: [Metric]) {
        self.id = id
        self.title = title
        self.period = period
        self.metrics = metrics
        self.students = students
        self.assignments = assignments
        self.seats = seats
        self.desk = desk
        self.notes = notes
        self.lessons = lessons
        self.templates = templates
    }
}
