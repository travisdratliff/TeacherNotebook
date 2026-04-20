//
//  Importer.swift
//  TeacherNotebook2
//
//  Created by Travis Domenic Ratliff on 3/21/26.
//
import SwiftUI
import SwiftData

enum Importer {
    static func importStudents(from url: URL) -> [Student] {
        var students: [Student] = []
        guard let contents = try? String(contentsOf: url, encoding: .utf8) else {
            print("Couldn't read file")
            return []
        }
        let rows = contents.components(separatedBy: .newlines)
        for row in rows.dropFirst() {
            let columns = row.components(separatedBy: ",")
            guard columns.count >= 3 else { continue }
            students.append(Student(
                id: columns[0].trimmingCharacters(in: .whitespaces),
                firstName: columns[1].trimmingCharacters(in: .whitespaces),
                lastName: columns[2].trimmingCharacters(in: .whitespaces)
            ))
        }
        return students
    }
//    static func importStudents(from url: URL, to course: Course) {
//        var students: [Student] = []
//        guard let contents = try? String(contentsOf: url, encoding: .utf8) else {
//            print("Couldn't read file")
//            return 
//        }
//        let rows = contents.components(separatedBy: .newlines)
//        for row in rows.dropFirst() {
//            let columns = row.components(separatedBy: ",")
//            guard columns.count >= 3 else { continue }
//            students.append(Student(
//                id: columns[0].trimmingCharacters(in: .whitespaces),
//                firstName: columns[1].trimmingCharacters(in: .whitespaces),
//                lastName: columns[2].trimmingCharacters(in: .whitespaces)
//            ))
//        }
//        for student in students {
//            guard !course.students.contains(where: { $0.id == student.id }) else { continue }
//            course.students.append(student)
//            course.seats.append(Seat(id: student.id, firstName: student.firstName, lastName: student.lastName))
//        }
//    }
    static func appendStudents(course: Course, parsed: [Student]) {
        for student in parsed {
            guard !course.students.contains(where: { $0.id == student.id }) else { continue }
            course.students.append(student)
            course.seats.append(Seat(id: student.id, firstName: student.firstName, lastName: student.lastName))
        }
    }
    static func importAssignments(from url: URL) -> [Assignment] {
        return []
    }
    static func importLessonsLessons(from url: URL) -> [Lesson] {
        return []
    }
}
