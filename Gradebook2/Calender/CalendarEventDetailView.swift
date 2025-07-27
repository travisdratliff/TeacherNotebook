//
//  CalendarEventDetailView.swift
//  Gradebook2
//
//  Created by Travis Domenic Ratliff on 1/20/25.
//

import SwiftUI
import SwiftData
import SwiftfulRouting
//import UserNotifications

struct CalendarEventDetailView: View {
    
    @Environment(\.router) var router
    @Environment(\.modelContext) var modelContext
    
    var events: [CalendarItem]
    var day: Date
    
    @State var showAlert = false
    @State var event = CalendarItem(title: "", content: "", itemDate: Date.now)
    
    var body: some View {
        List {
            Section {
                ForEach(events.sorted { $0.itemDate < $1.itemDate }) { event in
                    if event.itemDate.formatted(.dateTime.day().month()) == day.formatted(.dateTime.day().month()) {
                        VStack(alignment: .leading) {
                            HStack {
                                Text(event.title)
                                    .bold()
                                Spacer()
                                Menu {
                                    Button("Event Settings", systemImage: "gearshape") {
                                        router.showScreen(.sheet) { _ in
                                            EditEventView(event: event)
                                        }
                                    }
                                    Divider()
                                    Button("Delete Event", systemImage: "trash", role: .destructive) {
                                        self.event = event
                                        self.showAlert.toggle()
                                    }
                                } label: {
                                    Image(systemName: "line.3.horizontal")
                                        .font(.title2)
                                }
                            }
                            Text("\(event.itemDate.formatted(.dateTime.hour().minute())) - \(event.itemEndTime.formatted(.dateTime.hour().minute()))")
                            if let content = event.content {
                                Text(content)
                                    .foregroundStyle(.secondary)
                                    .lineLimit(2)
                                    .truncationMode(.tail)
                            }
                        }
                        .alert("Are you sure you want to delete this event?", isPresented: self.$showAlert) {
                            Button("Cancel", role: .cancel) { }
                            Button("Delete", role: .destructive) {
                                modelContext.delete(event)
                            }
                        }
                    }
                }
            } header: {
                Text("Events")
            }
        }
        .listStyle(.plain)
        .navigationTitle(day.formatted(.dateTime.month().day().year()))
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button("", systemImage: "minus") {
                    router.dismissScreen()
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button("", systemImage: "calendar.badge.plus") {
                    router.showScreen(.sheet) { _ in
                        AddCalendarEventView(day: day)
                    }
                }
            }
        }
        
    }
}

//#Preview {
//    CalendarEventDetailView()
//}
