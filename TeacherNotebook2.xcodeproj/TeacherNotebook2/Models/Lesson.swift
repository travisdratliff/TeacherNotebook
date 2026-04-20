//
//  Lesson.swift
//  TeacherNotebook2
//
//  Created by Travis Domenic Ratliff on 3/21/26.
//
import SwiftUI
import SwiftData

@Model
class Lesson {
    var title = ""
    var agenda: AttributedString = "Type agenda..."
    var dateWritten = Date.now
    var dateTaught = Date.now
    var metrics = [Metric]()
    var lessonTemplate: LessonTemplate
    init(title: String = "", dateWritten: Foundation.Date = Date.now, dateTaught: Foundation.Date = Date.now, lessonTemplate: LessonTemplate) {
        self.title = title
        self.dateWritten = dateWritten
        self.dateTaught = dateTaught
        self.lessonTemplate = lessonTemplate
    }
}

@Model
class LessonTemplate {
    var title = ""
    var textFields = [LessonTextField]()
    var dropDowns = [LessonDropDown]()
    init(textFields: [LessonTextField] = [LessonTextField](), dropDowns: [LessonDropDown] = [LessonDropDown]()) {
        self.title = title
        self.textFields = textFields
        self.dropDowns = dropDowns
    }
}

@Model
class LessonTextField {
    var title: String
    var order: Int
    var content: String
    init(title: String, order: Int, content: String) {
        self.title = title
        self.order = order
        self.content = content
    }
}

@Model
class LessonDropDown {
    var title: String
    var currentChoice: String
    var choices: [String]
    init(title: String, choices: [String]) {
        self.title = title
        if choices.count == 0 {
            self.currentChoice = ""
        } else {
            self.currentChoice = choices[0]
        }
        self.choices = choices
    }
}

