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
    var dateWritten = Date.now
    var content: AttributedString = "Type here..."
    init(course: Course) {
        self.course = course
        self.dateWritten = dateWritten
        self.content = content
    }
}
