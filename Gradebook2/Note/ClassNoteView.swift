//
//  ClassNoteView.swift
//  Gradebook2
//
//  Created by Travis Domenic Ratliff on 1/25/25.
//

import SwiftUI
import SwiftData
import SwiftfulRouting

struct ClassNoteView: View {
    @Environment(\.router) var router
    @Environment(\.modelContext) var modelContext
    
    var cn: ClassNote
    
    @State var showAlert = false
    
    var body: some View {
        List {
            Text(cn.content)
                .listRowSeparator(.hidden, edges: .bottom)
        }
        .listStyle(.plain)
   
        .navigationTitle("\(cn.dateWritten, style: .date)")
        .toolbar {
            Menu {
                Button("Note Settings", systemImage: "gearshape") {
                    router.showScreen(.sheet) { _ in
                        EditClassNoteView(cn: cn)
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
                modelContext.delete(cn)
                router.dismissScreen()
            }
        }
    }
}

//#Preview {
//    ClassNoteView()
//}
