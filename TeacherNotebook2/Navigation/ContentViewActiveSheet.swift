//
//  ActiveSheet.swift
//  TeacherNotebook2
//
//  Created by Travis Domenic Ratliff on 3/21/26.
//

enum ContentViewActiveSheet: Identifiable {
    var id: Self { self }
    case newCourse
    case newEvent
    case teacherSettings
    case calendarSettings
}
