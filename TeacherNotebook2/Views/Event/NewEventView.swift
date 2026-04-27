//
//  NewEventView.swift
//  TeacherNotebook2
//
//  Created by Travis Domenic Ratliff on 3/21/26.
//

import SwiftUI
import SwiftData
import MapKit
import CoreLocation

struct NewEventView: View {
    //
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    @Environment(\.colorScheme) var scheme
    //
    @State var title = ""
    @State var position = MapCameraPosition.userLocation(fallback: .automatic)
    @State var query = ""
    @State var searchedCoordinate: CLLocationCoordinate2D? = nil
    @State var description = ""
    @State var startDate = Date.now
    @State var endDate = Date.now
    @State var longitude: Double? = nil
    @State var latitude: Double? = nil
    @State var dayBeforeIsOn = false
    @State var hourBeforeIsOn = false
    @State var mapSearch = ""
    @State var locationAddress: String? = nil
    @State var shortAddress: String? = nil
    @State var mapItem: MKMapItem? = nil
    //
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
                    TextField("Search", text: $query)
                        .listRowSeparator(.hidden)
                        .onSubmit {
                            Task {
                                await searchLocation(query: query)
                            }
                        }
                    GeometryReader { geo in
                        Map(position: $position) {
                            UserAnnotation()
                            if let coord = searchedCoordinate {
                                Annotation(query, coordinate: coord) {
                                    Button {
                                        Task {
                                            let location = CLLocation(latitude: coord.latitude, longitude: coord.longitude)
                                            await locationAddress = getAddress(coordinate: location).fullAddress
                                            await shortAddress = getAddress(coordinate: location).shortAddress
                                        }
                                    } label: {
                                        Image(systemName: "plus.circle.fill")
                                            .foregroundStyle(.red)
                                            .font(.title)
                                    }
                                }
                            }
                        }
                        .mapControls {
                            MapUserLocationButton()
                        }
                        .frame(height: geo.size.width)
                    }
                    .aspectRatio(1.0, contentMode: .fit)
                    .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                    .listRowSeparator(.hidden)
                    if let locationAddress {
                        Text(locationAddress)
                    }
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
                            modelContext.insert(makeEvent())
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
    func searchLocation(query: String) async {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = query
        let search = MKLocalSearch(request: request)
        guard let response = try? await search.start() else { return }
        if let first = response.mapItems.first {
            let coord = first.location.coordinate
            searchedCoordinate = coord
            position = .region(MKCoordinateRegion(
                center: coord,
                span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            ))
        }
    }
    func getAddress(coordinate: CLLocation) async -> (fullAddress: String, shortAddress: String) {
        if let request = MKReverseGeocodingRequest(location: coordinate) {
            let mapItems = try? await request.mapItems
            if let mapItem = mapItems?.first {
                return (mapItem.address?.fullAddress ?? "No Address Listed", mapItem.address?.shortAddress ?? "No Address Listed")
            }
        }
        return ("No Address Listed", "No Address LIsted")
    }
    func makeEvent() -> Event {
        let event  = Event(title: title, startDate: startDate)
        if let searchedCoordinate {
            event.latitude = searchedCoordinate.latitude
            event.longitude = searchedCoordinate.longitude
        }
        if let locationAddress, let shortAddress {
            event.address = locationAddress
            event.shortAddress = shortAddress
        }
        if !description.trimmed().isEmpty {
            event.details = description
        }
        return event
    }
}

//#Preview {
//    NewEventView()
//}
