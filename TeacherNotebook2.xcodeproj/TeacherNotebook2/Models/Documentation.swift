//
//  Documentation.swift
//  TeacherNotebook2
//
//  Created by Travis Domenic Ratliff on 3/21/26.
//
import SwiftUI
import SwiftData

@Model
class Documentation {
    var dateWritten: Date
    var title: String
    var content: String
    init(dateWritten: Date, title: String, content: String) {
        self.dateWritten = dateWritten
        self.title = title
        self.content = content
    }
}
