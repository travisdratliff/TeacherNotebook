//
//  Day.swift
//  TeacherNotebook2
//
//  Created by Travis Domenic Ratliff on 3/21/26.
//
import SwiftUI

struct Day: Identifiable, Hashable {
    var id: String { "\(year)-\(month)-\(day)" }
    // let id = UUID()
    var dateMatch: String {
        String(format: "%04d-%02d-%02d", year, month, day)
    }
    let day: Int
    let month: Int
    let year: Int
}
