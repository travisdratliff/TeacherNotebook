//
//  AddClassNoteView.swift
//  Gradebook2
//
//  Created by Travis Domenic Ratliff on 1/25/25.
//

import SwiftUI
import SwiftData
import SwiftfulRouting

struct AddClassNoteView: View {
    
    @Environment(\.router) var router
    @Environment(\.modelContext) var modelContext
    
    @State var content = ""
    
    var body: some View {
        List {
            TextField("Content", text: $content, axis: .vertical)
                .listRowSeparator(.hidden, edges: .bottom)
        }
        .listStyle(.plain)

        .navigationTitle("New Class Note")
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button("", systemImage: "minus") {
                    router.dismissScreen()
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button("", systemImage: "plus") {
                    let classNote = ClassNote(content: content.trim(), dateWritten: Date.now)
                    modelContext.insert(classNote)
                    do {
                        try modelContext.save()
                    } catch {
                        print(error.localizedDescription)
                    }
                    router.dismissScreen()
                }
                .disabled(content.trim().isEmpty)
            }
        }
        .interactiveDismissDisabled()
    }
}

//#Preview {
//    AddClassNoteView()
//}
