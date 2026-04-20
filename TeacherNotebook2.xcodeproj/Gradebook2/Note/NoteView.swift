//
//  SwiftUIView.swift
//  Gradebook2
//
//  Created by Travis Domenic Ratliff on 1/25/25.
//

import SwiftUI
import SwiftData
import SwiftfulRouting

struct NoteView: View {
    
    @Environment(\.router) var router
    @Environment(\.modelContext) var modelContext
    
    var n: Note
    var s: Student
    
    @State var showAlert = false
    
    var body: some View {
        List {
            Text(n.content)
                .listRowSeparator(.hidden, edges: .bottom)
        }
        .listStyle(.plain)
     
        .navigationTitle("\(n.dateWritten, style: .date)")
        .toolbar {
            Menu {
                Button("Note Settings", systemImage: "gearshape") {
                    router.showScreen(.sheet) { _ in
                        EditNoteView(n: n)
                    }
                }
                Divider()
                Button("Delete Note", systemImage: "trash", role: .destructive) {
                    showAlert.toggle()
                }
            } label: {
                MenuLabel()
            }
        }
        .alert("Are you sure you want to delete this note?", isPresented: $showAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                if let index = s.notes.firstIndex(of: n) {
                    s.notes.remove(at: index)
                }
                router.dismissScreen()
            }
        }
    }
}

//#Preview {
//    let config = ModelConfiguration(isStoredInMemoryOnly: true)
//    let container = try! ModelContainer(for: Note.self, configurations: config)
//    let note = Note(dateWritten: Date.now, content: "blah blah blah")
//        return NoteView(n: note)
//            .modelContainer(container)
//}
