//
//  NewFieldTripView.swift
//  TeacherNotebook2
//
//  Created by Travis Domenic Ratliff on 4/25/26.
//

import SwiftUI

struct NewFieldTripView: View {
    @Environment(\.dismiss) var dismiss
    var body: some View {
        NavigationStack {
            List {
                CameraView()
                    .frame(height: 400)
                    .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
            }
            .navigationTitle("New Field Trip")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "minus")
                    }
                }
            }
        }
    }
}

//#Preview {
//    NewFieldTripView()
//}
