//
//  DocumentationView.swift
//  TeacherNotebook2
//
//  Created by Travis Domenic Ratliff on 4/25/26.
//

import SwiftUI

struct DocumentationView: View {
    @Bindable var course: Course
    @Binding var path: NavigationPath
    @State var pickedType = NoteType.log
    var body: some View {
        List {
            Picker("", selection: $pickedType) {
                ForEach(NoteType.allCases) { type in
                    Text(type.rawValue)
                }
            }
            .pickerStyle(.segmented)
            ForEach(course.notes.filter { $0.type == pickedType}) { note in
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
        .navigationTitle("Documentation")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Menu {
                    Button("New Note") {
                        newNote(type: .note)
                    }
                    Button("New Call Log") {
                        newNote(type: .log)
                    }
                    Button("New Incident Report") {
                        newNote(type: .report)
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                }
                .tint(.primary)
            }
            ToolbarItem(placement: .principal) {
                Text("\(course.title) - \(course.period)")
            }
        }
    }
    func newNote(type: NoteType) {
        let note = Note(course: course, type: type)
        course.notes.append(note)
        path.append(Route.noteDetail(course: course, note: note))
    }
}

//#Preview {
//    DocumentationView()
//}
