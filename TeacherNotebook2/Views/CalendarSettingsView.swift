//
//  CalendarSettingsView.swift
//  TeacherNotebook2
//
//  Created by Travis Domenic Ratliff on 3/21/26.
//

import SwiftUI

struct CalendarSettingsView: View {
    @Environment(\.dismiss) var dismiss
    var body: some View {
        NavigationStack {
            List {
                // these will be textfields
                Text("Settings")
            }
            .navigationTitle("Calendar Settings")
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "square.and.arrow.down")
                    }
                    .tint(.primary)
                }
            }
        }
    }
}

//#Preview {
//    CalendarSettingsView()
//}
