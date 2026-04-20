//
//  GradingWeight.swift
//  TeacherNotebook2
//
//  Created by Travis Domenic Ratliff on 3/21/26.
//

import SwiftUI
import SwiftData

@Model
class GradingWeight {
    var id = UUID()
    var title: String
    var percentage: Double
    var red: Double
    var green: Double
    var blue: Double
    init(id: UUID = UUID(), title: String, percentage: Double, red: Double, green: Double, blue: Double) {
        self.id = id
        self.title = title
        self.percentage = percentage
        self.red = red
        self.green = green
        self.blue = blue
    }
}

enum Weight: String, CaseIterable, Identifiable, Codable {
    case all, daily, project, test
    var id: Self { self }
}
