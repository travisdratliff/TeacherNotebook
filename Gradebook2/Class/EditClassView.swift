//
//  EditClassView.swift
//  Gradebook2
//
//  Created by Travis Domenic Ratliff on 1/22/25.
//

import SwiftUI
import SwiftData
import SwiftfulRouting

struct EditClassView: View {
    @Environment(\.router) var router
    @Environment(\.modelContext) var modelContext
    
    @Query var classes: [Class]
    
    var c: Class
    
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
        .navigationTitle("Edit Class")
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
                    let oldPeriod = c.period
                    if period == oldPeriod {
                        c.period = period
                        c.title = title
                        do {
                            try modelContext.save()
                        } catch {
                            print(error.localizedDescription)
                        }
                        router.dismissScreen()
                    } else if classes.contains(where: { $0.period == period }) {
                        router.showBasicAlert(text: "There is already a class for this period.") {
                            period = oldPeriod
                        }
                    } else {
                        c.title = title
                        c.period = period
                        do {
                            try modelContext.save()
                        } catch {
                            print(error.localizedDescription)
                        }
                        router.dismissScreen()
                    }
                } label: {
                    Image(systemName: "checkmark")
                }
                .disabled(!isValid)
            }
        }
        .onAppear {
            title = c.title
            period = c.period
        }
    }
}

//#Preview {
//    EditClassView()
//}
