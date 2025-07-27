//
//  AddNoteView.swift
//  Gradebook2
//
//  Created by Travis Domenic Ratliff on 1/19/25.
//

import SwiftUI
import SwiftData
import SwiftfulRouting

struct AddLessonView: View {
    
    @Environment(\.router) var router
    @Environment(\.modelContext) var modelContext
    
    var c: Class
    var isValid: Bool {
        !title.trim().isEmpty && !content.trim().isEmpty
    }
    
    @State var title = ""
    @State var content = ""
    @State var lessonDate = Date.now
    
    var body: some View {
        List {
            Section {
                TextField("Title", text: $title)
                TextField("Content (text will wrap)", text: $content, axis: .vertical)
                DatePicker("Lesson Date", selection: $lessonDate, displayedComponents: .date)
                    .datePickerStyle(.compact)
            } header: {
                Text("Details")
            }
        }
        .listStyle(.plain)
        .navigationTitle("New Lesson")
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button("", systemImage: "minus") {
                    router.dismissScreen()
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button("", systemImage: "plus") {
                    let lesson = Lesson(title: title.trim(), content: content.trim(), lessonDate: lessonDate)
                    c.lessons.append(lesson)
                    router.dismissScreen()
                }
                .disabled(!isValid)
            }
        }
    }
}

//#Preview {
//    AddNoteView()
//}
