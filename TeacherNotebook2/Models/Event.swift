//
//  Event.swift
//  TeacherNotebook2
//
//  Created by Travis Domenic Ratliff on 3/21/26.
//

import SwiftUI
import SwiftData
import MapKit

@Model
class Event {
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    var id = UUID()
    var title: String
    var details: String?
    var startDate: Date
    var endDate: Date?
    var latitude: Double?
    var longitude: Double?
    var location: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude ?? 0.0, longitude: longitude ?? 0.0)
    }
    var dateString: String {
        Event.dateFormatter.string(from: startDate)
    }
    init(id: UUID = UUID(), title: String, description: String? = nil, startDate: Date, endDate: Date? = nil, latitude: Double? = nil, longitude: Double? = nil) {
        self.id = id
        self.title = title
        self.details = description
        self.startDate = startDate
        self.endDate = endDate
        self.latitude = latitude
        self.longitude = longitude
    }
}

