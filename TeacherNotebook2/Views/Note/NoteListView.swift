//
//  NoteListView.swift
//  TeacherNotebook2
//
//  Created by Travis Domenic Ratliff on 3/21/26.
//

import SwiftUI

struct NoteListView: View {
    @Binding var path: NavigationPath
    @Bindable var course: Course
    var body: some View {
        List {
            ForEach(course.notes) { note in
                Button {
                    path.append(Route.noteDetail(course: course, note: note))
                } label: {
                    HStack {
                        Text(note.dateWritten, format: .dateTime)
                        Text(note.content)
                            .foregroundStyle(.secondary)
                            .truncationMode(.tail)
                            .lineLimit(1)
                        Spacer()
                        Image(systemName: "chevron.right")
                    }
                }
            }
        }
        .navigationTitle("Notes")
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
            ToolbarItem(placement: .principal) {
                Text(course.title)
                    .foregroundStyle(.secondary)
            }
            ToolbarItem(placement: .topBarTrailing) {
                Menu {
                    Button("New Note") {
                        let newNote = Note(course: course)
                        course.notes.append(newNote)
                        path.append(Route.noteDetail(course: course, note: newNote))
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                }
                .tint(.primary)
            }
        }
    }
}

//#Preview {
//    NoteListView()
//}
