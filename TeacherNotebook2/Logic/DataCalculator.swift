//
//  DataCalculator.swift
//  TeacherNotebook2
//
//  Created by Travis Domenic Ratliff on 4/28/26.
//

import SwiftUI

enum DataCalculator {
    static func amountPassingPerCategory(weight: GradingWeight, course: Course) -> Double {
        let assignments = course.assignments.filter { $0.weight == weight }
        let grades = assignments.flatMap(\.grades).filter { $0.score != nil }
        guard !grades.isEmpty else { return 0.0 }
        let passing = grades.filter { $0.score ?? 0.0 >= course.passingGrade }.count
        return (Double(passing) / Double(grades.count)) * 100
    }
    static func amountPassingByAverage(course: Course) -> Double {
        var amount = 0.0
        guard !course.students.isEmpty else { return 0.0 }
        for student in course.students {
            if calculateAverage(student: student, course: course).classAverage >= course.passingGrade {
                amount += 1
            }
        }
        let total = (amount * 100) / Double(course.students.count)
        return total
    }
    static func calculateAverage(student: Student, course: Course) -> (classAverage: Double, percentages: [GradingWeight: [Double]], hasGrades: Bool) {
        var average = 0.0
        let studentGrades = course.assignments.flatMap(\.grades).filter { $0.student == student }
        let percentagesDictionary = studentGrades.reduce(into: [GradingWeight: [Double]]()) { dictionary, grade in
            if let score = grade.score {
                dictionary[grade.weight, default: []].append(score)
            }
        }
        let totalWeight = percentagesDictionary.keys.map { $0.percentage }.reduce(0.0, +)
        guard totalWeight > 0 else { return (0.0, percentagesDictionary, false) }
        for (weight, grades) in percentagesDictionary {
            let normalizedWeight = weight.percentage / totalWeight
            let avg = (grades.reduce(0.0, +) / Double(grades.count)) * normalizedWeight
            average += avg
        }
        return (average, percentagesDictionary, true)
    }
    static func percentPassingMetric(metric: Metric, course: Course) -> Double {
        var amountPassing = 0.0
        var amountGraded = 0.0
        let assignmentList = course.assignments.filter { $0.metric == metric }.flatMap(\.grades)
        for assignment in assignmentList {
            if assignment.score != nil {
                amountGraded += 1
            }
            if let score = assignment.score {
                if score >= course.passingGrade {
                    amountPassing += 1
                }
            }
        }
        guard amountGraded > 0 else { return 0.0 }
        return (amountPassing / amountGraded) * 100
    }
    static func averageGradePerMetric(metric: Metric, course: Course) -> Double {
        var totalScore = 0.0
        var amountGraded = 0.0
        let gradesList = course.assignments.filter { $0.metric == metric }.flatMap(\.grades)
        for grade in gradesList {
            if grade.score != nil {
                amountGraded += 1
            }
            if let score = grade.score {
                totalScore += score
            }
        }
        guard amountGraded > 0 else { return 0.0 }
        return (totalScore / amountGraded)
    }
    static func findClassAverage(assignment: Assignment) -> Double? {
        var amount = 0.0
        var notNil = 0
        for grade in assignment.grades {
            amount += grade.score ?? 0.0
            if grade.score != nil {
                notNil += 1
            }
        }
        if notNil == 0 {
            return nil
        } else {
            return amount / Double(notNil)
        }
    }
    static func findStudentGrade(assignment: Assignment, student: Student) -> Double? {
        if let index = assignment.grades.firstIndex(where: { $0.student.id == student.id }) {
            if let filledScore = assignment.grades[index].score {
                return filledScore
            }
        }
        return nil
    }
    static func calculateStudentAverage(student: Student, course: Course) -> (classAverage: Double, percentages: [GradingWeight: [Double]], hasGrades: Bool) {
        var average = 0.0
        let studentGrades = course.assignments.flatMap(\.grades).filter { $0.student == student }
        let percentagesDictionary = studentGrades.reduce(into: [GradingWeight: [Double]]()) { dictionary, grade in
            if let score = grade.score {
                dictionary[grade.weight, default: []].append(score)
            }
        }
        let totalWeight = percentagesDictionary.keys.map { $0.percentage }.reduce(0.0, +)
        guard totalWeight > 0 else { return (0.0, percentagesDictionary, false) }
        for (weight, grades) in percentagesDictionary {
            let normalizedWeight = weight.percentage / totalWeight
            let avg = (grades.reduce(0.0, +) / Double(grades.count)) * normalizedWeight
            average += avg
        }
        return (average, percentagesDictionary, true)
    }
    static func percentStudentPassingMetric(student: Student, metric: Metric, course: Course) -> Double {
        var amountPassing = 0.0
        var amountGraded = 0.0
        let assignmentList = course.assignments.filter { $0.metric == metric }.flatMap(\.grades).filter { $0.student == student }
        for assignment in assignmentList {
            if assignment.score != nil {
                amountGraded += 1
            }
            if let score = assignment.score {
                if score >= course.passingGrade {
                    amountPassing += 1
                }
            }
        }
        return (amountPassing / amountGraded) * 100
    }
}

