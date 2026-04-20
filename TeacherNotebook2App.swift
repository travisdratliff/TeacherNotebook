//
//  TeacherNotebook2App.swift
//  TeacherNotebook2
//
//  Created by Travis Domenic Ratliff on 3/21/26.
//

import SwiftUI
import SwiftData

@main
struct TeacherNotebook2App: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [Lesson.self, Course.self, Assignment.self, Desk.self, Documentation.self, Event.self, Grade.self, GradingWeight.self, GradingPeriod.self, Seat.self, Student.self, Note.self, LessonTemplate.self, LessonTextField.self, LessonDropDown.self])
    }
}
