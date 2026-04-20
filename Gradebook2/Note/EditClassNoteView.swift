//
//  EditClassNoteView.swift
//  Gradebook2
//
//  Created by Travis Domenic Ratliff on 1/25/25.
//

import SwiftUI
import SwiftData
import SwiftfulRouting

struct EditClassNoteView: View {
    
    @Environment(\.router) var router
    @Environment(\.modelContext) var modelContext
    
    var cn: ClassNote
    
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

        .navigationTitle(Text(cn.dateWritten, style: .date))
//        .toolbar {
//            ToolbarItem(placement: .topBarLeading) {
//                Button("", systemImage: "minus") {
//                    router.dismissScreen()
//                }
//            }
//            ToolbarItem(placement: .topBarTrailing) {
//                Button("", systemImage: "checkmark") {
//                    cn.content = content
//                    router.dismissScreen()
//                }
//                .disabled(!isValid)
//            }
//        }
        .onAppear {
            content = cn.content
        }
        .onDisappear {
            cn.content = content
        }
        .interactiveDismissDisabled()
    }
}

//#Preview {
//    EditClassNoteView()
//}
