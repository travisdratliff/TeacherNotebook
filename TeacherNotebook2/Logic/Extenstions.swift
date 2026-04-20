//
//  Extensions.swift
//  TeacherNotebook2
//
//  Created by Travis Domenic Ratliff on 3/21/26.
//
import SwiftUI
import SwiftData

extension String {
    func trimmed() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    mutating func reset() {
        self = ""
    }
}

extension Double {
    mutating func clamped() {
        if self > 100.0 {
            self = 100.0
        } else if self < 0.0 {
            self = 0.0
        }
    }
}

extension ModelContext {
    func safeSave() {
        do {
            try save()
        } catch {
            print(error.localizedDescription)
        }
    }
}

extension Date {
    func yyyyDDmm() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: self)
    }
}
