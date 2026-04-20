//
//  LessonListView.swift
//  TeacherNotebook2
//
//  Created by Travis Domenic Ratliff on 3/21/26.
//

import SwiftUI
import SwiftData

struct LessonListView: View {
    @Environment(\.modelContext) var modelContext
    @Binding var path: NavigationPath
    @Query(sort: \Course.period) var courses: [Course]
    @Bindable var course: Course
    @State var showNewTemplate = false
    var body: some View {
        List {
            ForEach(course.lessons.sorted(by: { $0.dateTaught < $1.dateTaught })) { lesson in
                Button {
                    path.append(Route.lessonDetail(course: course, lesson: lesson))
                } label: {
                    HStack {
                        Text(lesson.title)
                        Spacer()
                        Text(lesson.dateTaught, style: .date)
                        Divider()
                        Image(systemName: "chevron.right")
                    }
                }
            }
        }
        .navigationTitle("Lessons")
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItemGroup(placement: .topBarLeading) {
                Button {
                    path.removeLast()
                } label: {
                    Image(systemName: "arrow.turn.up.left")
                }
                .tint(.primary)
                Menu {
                    Button("Home") {
                        path.removeLast(path.count)
                    }
                    if courses.count > 1 {
                        Divider()
                        ForEach(courses) { menuCourse in
                            if course.period != menuCourse.period {
                                Button("\(menuCourse.period) - \(menuCourse.title) Lessons") {
                                    Task {
                                        path.removeLast(path.count)
                                        try? await Task.sleep(for: .seconds(0.15))
                                        path.append(Route.courseDetail(course: menuCourse))
                                        try? await Task.sleep(for: .seconds(0.15))
                                        path.append(Route.lessonList(course: menuCourse))
                                    }
                                }
                            }
                        }
                    }
                } label: {
                    Image(systemName: "arrow.uturn.backward.circle.badge.ellipsis")
                }
            }
            ToolbarItem(placement: .principal) {
                Text(course.title)
                    .foregroundStyle(.secondary)
            }
            ToolbarItem(placement: .topBarTrailing) {
                Menu {
                    Button("New Lesson") {
                        createLesson(template: LessonTemplate())
                    }
                    if !course.templates.isEmpty {
                        Menu("New Lesson From Template") {
                            ForEach(course.templates) { template in
                                Button(template.title) {
                                    createLesson(template: template)
                                }
                            }
                        }
                    }
                    Divider()
                    Button("New Template") { showNewTemplate.toggle() }
                } label: {
                    Image(systemName: "ellipsis.circle")
                }
                .tint(.primary)
            }
        }
        .sheet(isPresented: $showNewTemplate) {
            NewTemplateView(course: course)
        }
    }
    func createLesson(template: LessonTemplate) {
        let lesson = Lesson(lessonTemplate: template)
        course.lessons.append(lesson)
        try? modelContext.save()
        path.append(Route.lessonDetail(course: course, lesson: lesson))
    }
}

//#Preview {
//    LessonListView()
//}

