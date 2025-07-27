//
//  EditLessonView.swift
//  Gradebook2
//
//  Created by Travis Domenic Ratliff on 1/21/25.
//

import SwiftUI
import SwiftData
import SwiftfulRouting

struct EditLessonView: View {
    
    @Environment(\.router) var router
    @Environment(\.modelContext) var modelContext
    
    var lesson: Lesson
    
    @State var title = ""
    @State var content = ""
    @State var lessonDate = Date.now
    
    var isValid: Bool {
        !title.trim().isEmpty && !content.trim().isEmpty
    }
    
    var body: some View {
        List {
            TextField("Title", text: $title)
            TextField("Content (text will wrap)", text: $content, axis: .vertical)
            DatePicker("Lesson Date", selection: $lessonDate, displayedComponents: .date)
                .datePickerStyle(.compact)
        }
        .listStyle(.plain)
        .navigationTitle("Edit Lesson")
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button("", systemImage: "minus") {
                    router.dismissScreen()
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button("", systemImage: "checkmark") {
                    lesson.title = title
                    lesson.content = content
                    lesson.lessonDate = lessonDate
                    do {
                        try modelContext.save()
                    } catch {
                        print(error.localizedDescription)
                    }
                    router.dismissScreen()
                }
                .disabled(!isValid)
            }
        }
        .onAppear {
            title = lesson.title
            content = lesson.content
            lessonDate = lesson.lessonDate
        }
    }
}

//#Preview {
//    EditLessonView()
//}
