//
//  ClassListView.swift
//  Gradebook2
//
//  Created by Travis Domenic Ratliff on 1/19/25.
//

import SwiftUI
import SwiftData
import SwiftfulRouting

struct ClassListView: View {
    
    @Environment(\.router) var router
    @Environment(\.modelContext) var modelContext
    
    @Query var classes: [Class]
    @Query var classNotes: [ClassNote]
    @Query var events: [CalendarItem]
    
    @State var tag = 1
    
    let daysOfWeek = Date.capitalizedFirstLettersOfWeekdays
    let columns = Array(repeating: GridItem(.flexible()), count: 7)
    @State var days: [Date] = []
    @State var date = Date.now
    @State var badge = 0
    
    var body: some View {
        TabView(selection: $tag) {
            // classes
            List {
                Section {
                    ForEach(classes.sorted { $0.period < $1.period }) { c in
                        Button {
                            router.showScreen(.push) { _ in
                                ClassDetailView(c: c)
                            }
                        } label: {
                            
                            HStack {
                                Text(c.period)
                                    .foregroundStyle(.secondary)
                                Text(c.title)
                                Spacer()
                                Image(systemName: "chevron.right")
                            }
                            
                        }
                        .foregroundStyle(.primary)
                    }
                } header: {
                    Text("Classes")
                    
                }
            }
            .listStyle(.plain)
            .tabItem { Label("Classes", systemImage: tag == 1 ? "graduationcap.fill" : "graduationcap").environment(\.symbolVariants, .none) }
            .tag(1)
            
            // calendar
            List {
                Section {
                    // calendar buttons
                    HStack {
                        Image(systemName: "chevron.left")
                            .bold()
                            .padding(10)
                            .onTapGesture {
                                date = Calendar.current.date(byAdding: .month, value: -1, to: date)!
                            }
                        Spacer()
                        Text(date, format: .dateTime.month().year())
                            .bold()
                        Spacer()
                        Image(systemName: "chevron.right")
                            .bold()
                            .padding(10)
                            .onTapGesture {
                                date = Calendar.current.date(byAdding: .month, value: 1, to: date)!
                            }
                    }
                    .frame(maxWidth: .infinity)
                    
                    // calendar days
                    HStack {
                        ForEach(daysOfWeek.indices, id: \.self) { index in
                            Text(daysOfWeek[index])
                                .bold()
                                .frame(maxWidth: .infinity)
                        }
                    }
                    
                    // calendar content
                    LazyVGrid(columns: columns) {
                        ForEach(days, id: \.self) { day in
                            if day.monthInt != date.monthInt {
                                Text("")
                            } else {
                                Button {
                                    router.showScreen(.sheet) { _ in
                                        CalendarEventDetailView(events: events, day: day)
                                    }
                                } label: {
                                    Text(day.formatted(.dateTime.day()))
                                        .foregroundStyle(.primary)
                                        .fontWeight(Date.now.startOfDay == day.startOfDay ? .bold : .light)
                                        .frame(maxWidth: .infinity, minHeight: 40)
                                        .background(
                                            Text("\(findAmountOfEvents(day: day))")
                                                .font(.caption)
                                                .padding(5)
                                                .foregroundStyle(findAmountOfEvents(day: day) == 0 ? .clear : Date.now.startOfDay > day.startOfDay ? .clear : .white)
                                                .background(findAmountOfEvents(day: day) == 0 ? .clear : Date.now.startOfDay > day.startOfDay ? .secondary : .red)
                                                .clipShape(Circle())
                                                .offset(x: 15, y: -15)
                                        )
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                } header: {
                    Text("Calendar")
                }
                .listRowSeparator(.hidden)
                
                //daily events
                Section {
                    ForEach(events.sorted { $0.itemDate < $1.itemDate }) { event in
                        if event.itemDate.formatted(.dateTime.day().month()) == Date.now.formatted(.dateTime.day().month()) {
                            VStack(alignment: .leading) {
                                HStack {
                                    Text(event.title)
                                        .bold()
                                    Spacer()
                                    Button {
                                        router.showScreen(.sheet) { _ in
                                            CalendarEventDetailView(events: events, day: event.itemDate)
                                        }
                                    } label: {
                                        Image(systemName: "arrow.up.forward.square")
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
                        }
                    }
                } header: {
                    Text("Today's Events")
                }
            }
            .listStyle(.plain)
            .tabItem { Label("Calendar", systemImage: "calendar").environment(\.symbolVariants, .none) }
            .badge(findBadgeNumber())
            .tag(2)
            .onAppear {
                days = date.calendarDisplayDays
            }
            .onChange(of: date) {
                days = date.calendarDisplayDays
            }
            
            // notes
            List {
                Section {
                    ForEach(classNotes) { cn in
                        Button {
                            router.showScreen(.push) { _ in
//                                ClassNoteView(cn: cn)
                                EditClassNoteView(cn: cn)
                            }
                        } label: {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(cn.dateWritten, style: .date)
                                        .bold()
                                    Text(cn.content)
                                        .foregroundStyle(.secondary)
                                        .lineLimit(2)
                                        .truncationMode(.tail)
                                }
                                Spacer()
                                Image(systemName: "chevron.right")
                            }
                        }
                    }
                } header: {
                    Text("Class Notes")
                }
            }
            .listStyle(.plain)
            .tabItem { Label("Class Notes", systemImage: "note.text").environment(\.symbolVariants, .none) }
            .tag(3)
            
        }
        .clipped()
        .toolbar {
            ToolbarItemGroup(placement: .topBarLeading) {
                Text("Teacher Notebook")
                    .font(Font.custom("Rubik-Medium", size: 20)) 
            }
            ToolbarItem(placement: .topBarTrailing) {
                Menu {
                    Button("New Class", systemImage: "graduationcap") {
                        router.showScreen(.sheet) { _ in
                            AddClassView()
                        }
                    }
                    Button("New Note", systemImage: "note.text") {
                        let classNote = ClassNote(content: "")
                        router.showScreen(.push) { _ in
//                            AddClassNoteView()
                            EditClassNoteView(cn: classNote)
                        }
                        modelContext.insert(classNote)
                    }
                } label: {
                    MenuLabel()
                }
            }
        }
    }
    func findAmountOfEvents(day: Date) -> Int {
        var amount = 0
        events.forEach { item in
            if item.itemDate.formatted(.dateTime.day().month().year()) == day.formatted(.dateTime.day().month().year()) {
                amount += 1
            }
        }
        return amount
    }
    func findBadgeNumber() -> Int {
        var badge = 0
        events.forEach { item in
            if item.itemDate.formatted(.dateTime.day().month().year()) == Date.now.formatted(.dateTime.day().month().year()) {
                badge += 1
            }
        }
        return badge
    }
}


//#Preview {
//    ClassListView()
//}
