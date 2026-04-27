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
    var extendDescription = false
    var id = UUID()
    var title: String
    var details: String?
    var startDate: Date
    var endDate: Date?
    var latitude: Double?
    var longitude: Double?
    var address: String?
    var shortAddress: String?
    var dateString: String {
        Event.dateFormatter.string(from: startDate)
    }
    init(extendDescription: Bool = false, id: UUID = UUID(), title: String, details: String? = nil, startDate: Date, endDate: Date? = nil, latitude: Double? = nil, longitude: Double? = nil, address: String? = nil) {
        self.extendDescription = extendDescription
        self.id = id
        self.title = title
        self.details = details
        self.startDate = startDate
        self.endDate = endDate
        self.latitude = latitude
        self.longitude = longitude
        self.address = address
    }
}

