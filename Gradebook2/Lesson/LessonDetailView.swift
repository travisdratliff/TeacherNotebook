//
//  LessonDetailView.swift
//  Gradebook2
//
//  Created by Travis Domenic Ratliff on 1/21/25.
//

import SwiftUI
import SwiftData
import SwiftfulRouting

struct LessonDetailView: View {
    
    @Environment(\.router) var router
    @Environment(\.modelContext) var modelContext
    
    var lesson: Lesson
    var c: Class
    
    @State var showAlert = false
    
    var body: some View {
        List {
            Section {
                Text(lesson.content)
            } header: {
                Text(lesson.lessonDate, style: .date)
            }
        }
        .listStyle(.plain)
        .navigationTitle(lesson.title)
        .toolbar {
            Menu {
                Button("Lesson Settings", systemImage: "gearshape") {
                    router.showScreen(.sheet) { _ in
                        EditLessonView(lesson: lesson)
                    }
                }
                Divider()
                Button("Delete Lesson", systemImage: "trash", role: .destructive) {
                    if let index = c.lessons.firstIndex(of: lesson) {
                        c.lessons.remove(at: index)
                    }
                    router.dismissScreen()
                }
            } label: {
                MenuLabel()
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button("", systemImage: "chevron.left") {
                    router.dismissScreen()
                }
            }
        }
        .alert("Are you sure you want to delete this lesson?", isPresented: $showAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                if let index = c.lessons.firstIndex(of: lesson) {
                    c.lessons.remove(at: index)
                }
                router.dismissScreen()
            }
        }
        .navigationBarBackButtonHidden()
    }
}

//#Preview {
//    LessonDetailView()
//}
