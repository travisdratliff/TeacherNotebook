//
//  LessonDetailView.swift
//  TeacherNotebook2
//
//  Created by Travis Domenic Ratliff on 4/4/26.
//

import SwiftUI
import SwiftData

struct LessonDetailView: View {
    @Binding var path: NavigationPath
    @Environment(\.modelContext) var modelContext
    @State var title = ""
    @State var lessonDate = Date.now
    @Bindable var course: Course
    @Bindable var lesson: Lesson
    @State var pickedMetric: Metric?
    @State var useTemplate = false
    var body: some View {
        List {
            Section {
                TextField("Lesson Title", text: $lesson.title)
                DatePicker("Lesson Date", selection: $lesson.dateTaught, displayedComponents: .date)
                    .datePickerStyle(.compact)
                Picker("Metric", selection: $pickedMetric) {
                    ForEach(course.metrics) { metric in
                        Text(metric.title).tag(metric)
                    }
                }
            } header: {
                Text("info")
            }
            Section {
                ZStack(alignment: .topLeading) {
                    Text(lesson.agenda)
                        .opacity(0)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 4)
                    TextEditor(text: $lesson.agenda)
                }
            } header: {
                Text("agenda")
            }
            if !lesson.lessonTemplate.dropDowns.isEmpty || !lesson.lessonTemplate.textFields.isEmpty {
                Section {
                    ForEach(lesson.lessonTemplate.dropDowns.indices, id: \.self) { index in
                        Picker(lesson.lessonTemplate.dropDowns[index].title, selection: $lesson.lessonTemplate.dropDowns[index].currentChoice) {
                            ForEach(lesson.lessonTemplate.dropDowns[index].choices, id: \.self) { choice in
                                Text(choice).tag(choice)
                            }
                        }
                    }
                } header: {
                    Text("dropdowns")
                }
                ForEach(lesson.lessonTemplate.textFields.indices, id: \.self) { index in
                    Section {
                        TextField(lesson.lessonTemplate.textFields[index].title, text: $lesson.lessonTemplate.textFields[index].content, axis: .vertical)
                    } header: {
                        Text(lesson.lessonTemplate.textFields[index].title)
                    }
                }
            }
        }
        .navigationTitle(lesson.title)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItemGroup(placement: .topBarLeading) {
                Button {
                    path.removeLast()
                } label: {
                    Image(systemName: "arrow.turn.up.left")
                }
                Button {
                    path.removeLast(path.count)
                } label: {
                    Image(systemName: "house")
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                Menu {
                    Button("Delete Lesson", role: .destructive) {
                        if let index = course.lessons.firstIndex(of: lesson) {
                            course.lessons.remove(at: index)
                        }
                        try? modelContext.save()
                        path.removeLast()
                        print(course.lessons.count)
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                }
            }
        }
        .onAppear {
            if lesson.title.trimmed().isEmpty {
                lesson.title = ""
            }
            guard pickedMetric == nil else { return }
            pickedMetric = course.metrics.first
        }
    }
}

//#Preview {
//    LessonDetailView()
//}
