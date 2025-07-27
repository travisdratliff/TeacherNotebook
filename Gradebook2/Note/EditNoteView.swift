//
//  EditNoteView.swift
//  Gradebook2
//
//  Created by Travis Domenic Ratliff on 1/25/25.
//

import SwiftUI
import SwiftData
import SwiftfulRouting

struct EditNoteView: View {
    
    @Environment(\.router) var router
    @Environment(\.modelContext) var modelContext
    
    var n: Note
    
    @State var content = ""
    
    var isValid: Bool {
        !content.trim().isEmpty
    }
    
    var body: some View {
        List {
            TextField("Content", text: $content, axis: .vertical)
                .listRowSeparator(.hidden, edges: .bottom)
        }
        .listStyle(.plain)

        .navigationTitle(Text(n.dateWritten, style: .date))
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    n.content = content
                    router.dismissScreen()
                } label: {
                    Image(systemName: "chevron.left")
                }
                .tint(.primary)
            }
//            ToolbarItem(placement: .topBarLeading) {
//                Button("", systemImage: "minus") {
//                    router.dismissScreen()
//                }
//            }
//            ToolbarItem(placement: .topBarTrailing) {
//                Button("", systemImage: "checkmark") {
//                    n.content = content
//                    router.dismissScreen()
//                }
//                .disabled(!isValid)
//            }
        }
        .onAppear {
            content = n.content
        }
        .onDisappear {
            n.content = content
        }
        .interactiveDismissDisabled()
        .navigationBarBackButtonHidden()
    }
}

//#Preview {
//    EditNoteView()
//}
