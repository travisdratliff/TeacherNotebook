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
    @State var selection: TabCount = .one
    var body: some View {
        TabView(selection: $selection) {
            Tab("Notes", systemImage: "long.text.page.and.pencil", value: TabCount.one) {
                NoteListView(path: $path, course: course)
            }
            Tab("Call Logs", systemImage: "phone", value: TabCount.two) {
                
            }
            Tab("Docs", systemImage: "document", value: TabCount.three) {
                
            }
        }
        .navigationTitle(returnTitle(selection: selection))
        .toolbar {
            returnToolbar(selection: selection)
        }
    }
    func returnTitle(selection: TabCount) -> String {
        switch selection {
            case .one: "Notes"
            case .two: "Call Logs"
            case .three: "Documentation"
        }
    }
    @ToolbarContentBuilder
    func returnToolbar(selection: TabCount) -> some ToolbarContent {
        switch selection {
            case .one:
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
            case .two:
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Button("New Call Log") {
//                            let newNote = Note(course: course)
//                            course.notes.append(newNote)
//                            path.append(Route.noteDetail(course: course, note: newNote))
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                    }
                    .tint(.primary)
                }
            case .three:
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Button("New Document") {
//                            let newNote = Note(course: course)
//                            course.notes.append(newNote)
//                            path.append(Route.noteDetail(course: course, note: newNote))
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                    }
                    .tint(.primary)
                }
        }
    }
}

enum TabCount: Int {
    case one = 1, two = 2, three = 3
}

//#Preview {
//    DocumentationView()
//}
