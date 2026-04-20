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
    @State var isActive = false
    var body: some Scene {
        WindowGroup {
            ZStack {
                if isActive {
                    ContentView()
                        .transition(.opacity)
                } else {
                    SplashScreen()
                        .transition(.opacity)
                }
            }
            .animation(.easeInOut(duration: 0.5), value: isActive)
            .onAppear {
                Task {
                    try? await Task.sleep(for: .seconds(2))
                    self.isActive = true
                }
            }
            .modelContainer(for: [Lesson.self, Course.self, Assignment.self, Desk.self, Documentation.self, Event.self, Grade.self, GradingWeight.self, GradingPeriod.self, Seat.self, Student.self, Note.self, LessonTemplate.self, LessonTextField.self, LessonDropDown.self])
        }
    }
}
