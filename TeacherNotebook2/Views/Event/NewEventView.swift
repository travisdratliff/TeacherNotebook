//
//  NewEventView.swift
//  TeacherNotebook2
//
//  Created by Travis Domenic Ratliff on 3/21/26.
//

import SwiftUI
import SwiftData
import MapKit

struct NewEventView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    @Environment(\.colorScheme) var scheme
    @State var title = ""
    @State var position = MapCameraPosition.userLocation(fallback: .automatic)
    @State var description = ""
    @State var startDate = Date.now
    @State var endDate = Date.now
    @State var longitude: Double? = nil
    @State var latitude: Double? = nil
    @State var dayBeforeIsOn = false
    @State var hourBeforeIsOn = false
    @State var mapSearch = ""
    @State var searchResults = [MKMapItem]()
    var body: some View {
        NavigationStack {
            List {
                Section {
                    TextField("Event Title", text: $title)
                    TextField("Description (optional)", text: $description, axis: .vertical)
                    DatePicker("Date", selection: $startDate)
                        .datePickerStyle(.automatic)
                }
                Section {
                    GeometryReader { geo in
                        Map(position: $position) {
                            UserAnnotation()
                        }
                        .mapControls {
                            MapUserLocationButton()
                        }
                        .frame(height: geo.size.width)
                    }
                    .aspectRatio(1.0, contentMode: .fit)
                    .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                }
                Section {
                    Toggle(
                        "Day Before",
                        systemImage: "bell",
                        isOn: $dayBeforeIsOn
                    )
                    Toggle(
                        "Hour Before",
                        systemImage: "bell",
                        isOn: $hourBeforeIsOn
                    )
                }
                Section {
                    HStack {
                        Spacer()
                        Button {
                            modelContext.insert(Event(title: title, startDate: startDate))
                            try? modelContext.save()
                            dismiss()
                        } label: {
                            Text("Save")
                                .saveButtonModifier(scheme: scheme)
                        }
                        .buttonStyle(.borderless)
                    }
                    .listRowBackground(Color.clear)
                }
            }
            .navigationTitle("New Event")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "minus")
                    }
                    .tint(.primary)
                }
            }
            .onAppear {
                CLLocationManager().requestWhenInUseAuthorization()
            }
        }
    }
}

//#Preview {
//    NewEventView()
//}
