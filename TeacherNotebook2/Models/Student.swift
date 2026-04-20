//
//  Student.swift
//  TeacherNotebook2
//
//  Created by Travis Domenic Ratliff on 3/21/26.
//

import SwiftUI
import SwiftData

@Model
class Student {
    var id: String
    var firstName: String
    var lastName: String
    var fullName: String {
        firstName + " " + lastName
    }
//    var documentationList: [Documentation] = []
    init(id: String, firstName: String, lastName: String) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
    }
}
