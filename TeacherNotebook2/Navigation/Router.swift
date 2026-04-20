//
//  Router.swift
//  TeacherNotebook2
//
//  Created by Travis Domenic Ratliff on 3/21/26.
//
import SwiftUI

enum Route: Hashable {
    case dateCell(day: Day)
    case courseDetail(course: Course)
    case studentDetail(student: Student, course: Course)
    case assignmentDetail(assignment: Assignment)
    case noteDetail(course: Course, note: Note)
    case studentList(course: Course)
    case assignmentList(course: Course)
    case lessonList(course: Course)
    case noteList(course: Course)
    case dataView(course: Course)
    case studentGrade(student: Student, course: Course)
    case lessonDetail(course: Course, lesson: Lesson)
}
