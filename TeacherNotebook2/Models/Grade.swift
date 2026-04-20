//
//  Grade.swift
//  TeacherNotebook2
//
//  Created by Travis Domenic Ratliff on 3/21/26.
//
import SwiftUI
import SwiftData

@Model
class Grade {
    var weight: GradingWeight
    var student: Student
    var score: Double?
    init(weight: GradingWeight, student: Student, score: Double? = nil) {
        self.weight = weight
        self.student = student
        self.score = score
    }
}
