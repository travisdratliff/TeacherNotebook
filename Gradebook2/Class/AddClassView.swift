//
//  AddClassView.swift
//  Gradebook2
//
//  Created by Travis Domenic Ratliff on 1/19/25.
//

import SwiftUI
import SwiftData
import SwiftfulRouting

struct AddClassView: View {
    
    @Environment(\.router) var router
    @Environment(\.modelContext) var modelContext
    
    @Query var classes: [Class]
    
    @State var title = ""
    @State var period = ""
    
    var isValid: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && !period.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var body: some View {
        List {
            Section {
                TextField("Title", text: $title)
                TextField("Period", text: $period)
                    .keyboardType(.numberPad)
            } header: {
                Text("Details")
            }
        }
        .listStyle(.plain)
        .navigationTitle("New Class")
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    router.dismissScreen()
                } label: {
                    Image(systemName: "minus")
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    guard classes.contains(where: { $0.period == period }) else {
                        let c = Class(title: title, period: period)
                        modelContext.insert(c)
                        router.dismissScreen()
                        return
                    }
                    router.showBasicAlert(text: "There is already a class for this period.") {
                        period = ""
                    }
                } label: {
                    Image(systemName: "plus")
                }
                .disabled(!isValid)
            }
        }
    }
}

//#Preview {
//    AddClassView()
//}
