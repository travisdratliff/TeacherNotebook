//
//  CellDetailView.swift
//  TeacherNotebook2
//
//  Created by Travis Domenic Ratliff on 3/21/26.
//

import SwiftUI
import SwiftData
import MapKit

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
                        VStack(alignment: .leading) {
                            HStack {
                                Text(event.title)
                                    .fontWeight(event.extendDescription ? .bold : .regular)
                                Spacer()
                                Button {
                                    event.extendDescription.toggle()
                                } label: {
                                    Image(systemName: event.extendDescription ? "chevron.up" : "chevron.down")
                                }
                                .buttonStyle(.borderless)
                            }
                            if event.extendDescription {
                                VStack(alignment: .leading) {
                                    Text(event.startDate, format: .dateTime)
                                        .padding(.top)
                                    if let details = event.details {
                                        Divider()
                                        Text(details)
                                    }
                                    if let address = event.address, let shortAddress = event.shortAddress {
                                        Divider()
                                        HStack {
                                            Text(address)
                                            Spacer()
                                            Button {
                                                if let latitude = event.latitude, let longitude = event.longitude {
                                                    let mapItem = MKMapItem(location: CLLocation(latitude: latitude, longitude: longitude), address: MKAddress(fullAddress: address, shortAddress: shortAddress))
                                                    mapItem.openInMaps()
                                                }
                                            } label: {
                                                Image(systemName: "paperplane")
                                            }
                                            .buttonStyle(.borderless)
                                        }
                                    }
                                }
                            }
                        }
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
        }
        .onDisappear {
            for event in events {
                event.extendDescription = false
            }
        }
    }
}

//#Preview {
//    CellDetailView()
//}
