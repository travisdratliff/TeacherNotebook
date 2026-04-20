//
//  Seat.swift
//  TeacherNotebook2
//
//  Created by Travis Domenic Ratliff on 3/21/26.
//
import SwiftUI
import SwiftData

@Model
class Seat {
    var id: String
    var firstName: String
    var lastName: String
    var x: CGFloat = 0.0
    var y: CGFloat = 0.0
    init(id: String, firstName: String, lastName: String, x: CGFloat = 0.0, y: CGFloat = 0.0) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.x = x
        self.y = y
    }
}
