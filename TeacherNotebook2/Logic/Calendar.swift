//
//  Calendar.swift
//  TeacherNotebook2
//
//  Created by Travis Domenic Ratliff on 3/21/26.
//

import SwiftUI
import Observation

@Observable
@MainActor
final class CalendarMaker {
    var holidayCache: [Int: [Holiday]] = [:]
    var currentDate = Date()
    let location = Locale.current.region?.identifier ?? "US"
    let shortDays = Calendar.current.shortWeekdaySymbols
    var month: Int {
        Calendar.current.component(.month, from: currentDate)
    }
    var year: Int {
        Calendar.current.component(.year, from: currentDate)
    }
    var monthName: String {
        guard let date = Calendar.current.date(from: DateComponents(year: year, month: month)) else { return "" }
        return Self.monthFormatter.string(from: date)
    }
    var gridArray: [Int] {
        let components = Calendar.current.dateComponents([.year, .month], from: currentDate)
        guard let firstDay = Calendar.current.date(from: components) else { return [] }
        let firstWeekday = Calendar.current.component(.weekday, from: firstDay)
        var grid = Array(repeating: 0, count: max(0, firstWeekday - 1))
        let dayCount = Calendar.current.range(of: .day, in: .month, for: currentDate)?.count ?? 0
        grid.append(contentsOf: (1...dayCount))
        return grid
    }
    func changeMonth(by value: Int) {
        currentDate = Calendar.current.date(byAdding: .month, value: value, to: currentDate) ?? currentDate
    }
    func changeYear(by value: Int) {
        currentDate = Calendar.current.date(byAdding: .year, value: value, to: currentDate) ?? currentDate
    }
    private static let monthFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM"
        return formatter
    }()
    func fetchHolidays() async throws -> [Holiday] {
        guard let url = URL(string: "https://date.nager.at/api/v3/PublicHolidays/\(year)/\(location)") else { return [] }
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode([Holiday].self, from: data)
    }
    func cacheHolidays() async {
        guard holidayCache[year] == nil else { return }
        do {
            holidayCache[year] = try await fetchHolidays()
            print(year)
        } catch {
            print("Holiday fetch failed:", error.localizedDescription)
        }
    }
}
