//
//  CellDetailView.swift
//  TeacherNotebook2
//
//  Created by Travis Domenic Ratliff on 3/21/26.
//

import SwiftUI
import SwiftData

struct CellDetailView: View {
    @Binding var path: NavigationPath
    @Query var events: [Event]
    @Query var courses: [Course]
    @State var assignmentsForDay = [Assignment]()
    @State var showNewEvent = false
    let day: Day
    let holidays: [Holiday]
    var body: some View {
        List {
            Section {
                ForEach(events) { event in
                    if day.dateMatch == event.dateString {
                        Text(event.title)
                    }
                }
            } header: {
                Text("events")
            }
            Section {
                ForEach(holidays, id: \.date) { holiday in
                    if holiday.date == day.dateMatch {
                        Text(holiday.name)
                    }
                }
            } header: {
                Text("holidays")
            }
            Section {
                ForEach(courses.flatMap(\.assignments)) { assignment in
                    if assignment.dueDate.yyyyDDmm() == day.dateMatch {
                        HStack {
                            Text("\(assignment.courseTitle)")
                            Spacer()
                            Image(systemName: "rectangle.portrait.fill")
                                .foregroundStyle(Color(red: assignment.weight!.red, green: assignment.weight!.green, blue: assignment.weight!.blue))
                            Text("\(assignment.title)")
                        }
                    }
                }
            } header: {
                Text("assignments due")
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationTitle("\(day.month)/\(day.day)/\(String(day.year))")
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    path.removeLast()
                } label: {
                    Image(systemName: "minus")
                }
                .tint(.primary)
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    //                    showNewEvent.toggle()
                } label: {
                    Image(systemName: "calendar.badge.plus")
                }
                .tint(.primary)
            }
        }
    }
}

//#Preview {
//    CellDetailView()
//}
