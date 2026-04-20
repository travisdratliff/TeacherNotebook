//
//  NoteDetailView.swift
//  TeacherNotebook2
//
//  Created by Travis Domenic Ratliff on 3/21/26.
//

import SwiftUI

struct NoteDetailView: View {
    @Binding var path: NavigationPath
    var note: String
    var body: some View {
        List {
            
        }
        .navigationTitle(note)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItemGroup(placement: .topBarLeading) {
                Button {
                    path.removeLast()
                } label: {
                    Image(systemName: "arrow.turn.up.left")
                }
                .tint(.primary)
                Button {
                    path.removeLast(path.count)
                } label: {
                    Image(systemName: "house")
                }
                .tint(.primary)
            }
        }
    }
}

//#Preview {
//    NoteDetailView()
//}
