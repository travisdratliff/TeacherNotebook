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
                .tint(isDay ? AnyShapeStyle(LinearGradient(gradient: Gradient(colors: [Color(red: scheme == .dark ? 0.71 : 1, green: scheme == .dark ? 0.55 : 0.8, blue: scheme == .dark ? 0.82 : 0.68), Color(red: scheme == .dark ? 0.58 : 1, green: scheme == .dark ? 0.39 : 0.6, blue: scheme == .dark ? 0.73 : 0.59)]), startPoint: .top, endPoint: .bottom)) : AnyShapeStyle(Color.clear))
                .frame(height: 40)
            Text("\(day.day)")
                .font(.caption)
                .foregroundStyle(.primary)
                .frame(height: 40)
            HStack(spacing: 0) {
                if holidays.contains(where: { $0.date == day.dateMatch }) {
                    Image(systemName: "sparkle")
                        .foregroundStyle(.red)
                        .font(.system(size: 10))
                }
                if events.contains(where: { $0.dateString == day.dateMatch }) {
                    Image(systemName: "calendar")
                        .foregroundStyle(.red)
                        .font(.system(size: 10))
                }
                if courses.flatMap(\.assignments).contains(where: { $0.dueDate.yyyyDDmm() == day.dateMatch }) {
                    Image(systemName: "pencil.tip.crop.circle")
                        .foregroundStyle(.red)
                        .font(.system(size: 10))
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
