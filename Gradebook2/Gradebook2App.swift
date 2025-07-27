//
//  Gradebook2App.swift
//  Gradebook2
//
//  Created by Travis Domenic Ratliff on 1/18/25.
//

import SwiftUI
import SwiftData
import SwiftfulRouting

@main
struct Gradebook2App: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: [Class.self, Student.self, Assignment.self, AssignmentOriginal.self, Note.self, ClassNote.self, CalendarItem.self])
        }
    }
}
