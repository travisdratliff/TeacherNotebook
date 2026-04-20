//
//  NoteView.swift
//  TeacherNotebook2
//
//  Created by Travis Domenic Ratliff on 3/30/26.
//

import SwiftUI
import SwiftData

struct NoteView: View {
    @Environment(\.modelContext) var modelContext
    @Binding var path: NavigationPath
    @Bindable var course: Course
    @Bindable var note: Note
    var body: some View {
        List {
            ZStack(alignment: .leading) {
                Text(note.content)
                    .opacity(0)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 4)
                TextEditor(text: $note.content)
            }
        }
        .navigationTitle(Text(note.dateWritten, format: .dateTime))
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItemGroup(placement: .topBarLeading) {
                Button {
                    if note.content.characters.isEmpty {
                        if let index = course.notes.firstIndex(of: note) {
                            course.notes.remove(at: index)
                            try? modelContext.save()
                        }
                    }
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
//    NoteView()
//}
