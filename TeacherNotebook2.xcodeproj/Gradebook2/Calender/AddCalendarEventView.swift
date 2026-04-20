//
//  AddCalendarEventView.swift
//  Gradebook2
//
//  Created by Travis Domenic Ratliff on 1/20/25.
//

import SwiftUI
import SwiftData
import SwiftfulRouting

struct AddCalendarEventView: View {
    
    @Environment(\.router) var router
    @Environment(\.modelContext) var modelContext
    
    @State var title = ""
    @State var content = ""
    @State var itemDate = Date.now
    @State var itemEndTime = Date.now
    
    var day: Date
    
    var body: some View {
        List {
            Section {
                TextField("Title", text: $title)
                TextField("Location / Description (optional)", text: $content, axis: .vertical)
                DatePicker("Event Start Date/Time", selection: $itemDate)
                    .datePickerStyle(.compact)
                DatePicker("Event End Date/Time", selection: $itemEndTime)
                    .datePickerStyle(.compact)
            } header: {
                Text("Details")
            }
        }
        .listStyle(.plain)
        .navigationTitle("New Event")
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button("", systemImage: "minus") {
                    router.dismissScreen()
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button("", systemImage: "plus") {
                    let calendarItem = CalendarItem(title: title, content: content.trim().isEmpty ? content : nil, itemDate: itemDate, itemEndTime: itemEndTime)
                    modelContext.insert(calendarItem)
                    router.dismissScreen()
                }
                .disabled(title.trim().isEmpty)
            }
        }
        .onAppear {
            itemDate = day
        }
    }
}

//#Preview {
//    AddCalendarEventView()
//}
