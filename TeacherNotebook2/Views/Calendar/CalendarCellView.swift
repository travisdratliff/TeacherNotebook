//
//  CalendarCellView.swift
//  TeacherNotebook2
//
//  Created by Travis Domenic Ratliff on 3/21/26.
//

import SwiftUI
import SwiftData

struct CalendarCellView: View {
    @Environment(\.colorScheme) var scheme
    @Query var events: [Event]
    @Query var courses: [Course]
    static let components = Calendar.current.dateComponents([.day, .month, .year], from: Date())
    var isDay: Bool {
        day.day == Self.components.day! &&
        day.month == Self.components.month! &&
        day.year == Self.components.year!
    }
    let day: Day
    var holidays: [Holiday]
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .tint(Color.clear)
                .frame(height: 40)
                .overlay {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(isDay ? AnyShapeStyle(LinearGradient(gradient: Gradient(colors: [Color(red: scheme == .dark ? 0.71 : 1, green: scheme == .dark ? 0.55 : 0.8, blue: scheme == .dark ? 0.82 : 0.68), Color(red: scheme == .dark ? 0.58 : 1, green: scheme == .dark ? 0.39 : 0.6, blue: scheme == .dark ? 0.73 : 0.59)]), startPoint: .top, endPoint: .bottom)) : AnyShapeStyle(Color.clear), lineWidth: 2)
                }
            Text("\(day.day)")
                .font(.caption)
                .foregroundStyle(.primary)
                .frame(height: 40)
            HStack(spacing: 0) {
                Spacer()
                if holidays.contains(where: { $0.date == day.dateMatch }) {
                    Circle()
                        .fill(Color(red: 1.0, green: 0.41, blue: 0.38))
                        .frame(width: 7.5, height: 7.5)
                }
                if events.contains(where: { $0.dateString == day.dateMatch }) {
                    Circle()
                        .fill(Color(red: 0.70, green: 0.62, blue: 0.71))
                        .frame(width: 7.5, height: 7.5)
                }
                if courses.flatMap(\.assignments).contains(where: { $0.dueDate.yyyyDDmm() == day.dateMatch }) {
                    Circle()
                        .fill(Color(red: 0.68, green: 0.85, blue: 0.90))
                        .frame(width: 7.5, height: 7.5)
                }
            }
            .frame(width: 30)
            .offset(x: 0, y: -12)
        }
    }
}

//#Preview {
//    CalendarCellView()
//}
