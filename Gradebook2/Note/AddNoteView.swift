//
//  AddNoteView.swift
//  Gradebook2
//
//  Created by Travis Domenic Ratliff on 1/21/25.
//

import SwiftUI
import SwiftData
import SwiftfulRouting

struct AddNoteView: View {
    
    @Environment(\.router) var router
    @Environment(\.modelContext) var modelContext
    
    var s: Student
    
    @State var content = ""

    var body: some View {
        List {
            TextField("Content", text: $content, axis: .vertical)
                .listRowSeparator(.hidden, edges: .bottom)
        }
        .listStyle(.plain)
      
        .navigationTitle("New Note")
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button("", systemImage: "minus") {
                    router.dismissScreen()
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button("", systemImage: "plus") {
                    let note = Note(dateWritten: Date.now, content: content.trim())
                    s.notes.append(note)
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
//    AddNoteView()
//}
