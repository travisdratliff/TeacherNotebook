//
//  Untitled.swift
//  TeacherNotebook2
//
//  Created by Travis Domenic Ratliff on 3/21/26.
//
import SwiftUI

struct Holiday: Codable, Hashable {
    let date: String   // convert to Date later when ready
    let name: String
    let localName: String
}

struct NinjaHoliday: Codable, Hashable {
    let name: String
    let local_name: String
    let date: String
    let country: String
    let year: String
    let regions: [String]?
    let federal: Bool
}
