//
//  EditEventView.swift
//  Gradebook2
//
//  Created by Travis Domenic Ratliff on 1/21/25.
//

import SwiftUI
import SwiftData
import SwiftfulRouting

struct EditEventView: View {
    
    @Environment(\.router) var router
    @Environment(\.modelContext) var modelContext
    
    var event: CalendarItem
    
    @State var title = ""
    @State var content = ""
    @State var itemDate = Date.now
    @State var itemEndTime = Date.now
    
    var isValid: Bool {
        !title.trim().isEmpty
    }
    
    var body: some View {
        List {
            TextField("Title", text: $title)
            TextField("Location (optional)", text: $content, axis: .vertical)
            DatePicker("Event Date/Time", selection: $itemDate)
                .datePickerStyle(.compact)
            DatePicker("Event End Date/Time", selection: $itemEndTime)
                .datePickerStyle(.compact)
        }
        .listStyle(.plain)
        .navigationTitle("Edit Event")
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button("", systemImage: "minus") {
                    router.dismissScreen()
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button("", systemImage: "checkmark") {
                    event.title = title.trim()
                    if content.isEmpty {
                        event.content = nil
                    } else {
                        event.content = content.trim()
                    }
                    event.itemDate = itemDate
                    event.itemEndTime = itemEndTime
                    do {
                        try modelContext.save()
                    } catch {
                        print(error.localizedDescription)
                    }
                    router.dismissScreen()
                }
                .disabled(!isValid)
            }
        }
        .onAppear {
            title = event.title
            content = event.content ?? ""
            itemDate = event.itemDate
            itemEndTime = event.itemEndTime
        }
    }
}

//#Preview {
//    EditEventView()
//}
