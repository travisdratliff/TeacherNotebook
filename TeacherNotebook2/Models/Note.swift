//
//  Note.swift
//  TeacherNotebook2
//
//  Created by Travis Domenic Ratliff on 3/30/26.
//

import SwiftUI
import SwiftData

@Model
class Note {
    var course: Course
    var type: NoteType
    var dateWritten = Date.now
    var content: AttributedString = "Type here..."
    init(course: Course, type: NoteType) {
        self.course = course
        self.type = type
        self.dateWritten = dateWritten
        self.content = content
    }
}

enum NoteType: String, Codable, CaseIterable, Identifiable {
    case note = "Note"
    case log = "Call Log"
    case report = "Incident Report"
    var id: Self { self }
}
