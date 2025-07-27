//
//  ClassDetailView.swift
//  Gradebook2
//
//  Created by Travis Domenic Ratliff on 1/19/25.
//

import SwiftUI
import SwiftData
import SwiftfulRouting

struct ClassDetailView: View {
    
    @Environment(\.router) var router
    @Environment(\.modelContext) var modelContext
    
    var c: Class
    var weights = ["All", "Daily", "Quiz", "Project", "Test"]
    
    @State var tag = 1
    @State var pickedWeight = "All"
    @State var showDeleteAssignmentsAlert = false
    @State var showDeleteClassAlert = false
    
    var body: some View {
        TabView(selection: $tag) {
            
            // Students
            List {
                Section {
                    ForEach(c.students.sorted { $0.fullName < $1.fullName }) { s in
                        Button {
                            router.showScreen(.push) { _ in
                                StudentDetailView(s: s, c: c)
                            }
                        } label: {
                            HStack {
                                Text("\(s.lastName), \(s.firstName)")
                                Spacer()
                                Image(systemName: "chevron.right")
                            }
                        }
                        .foregroundStyle(.primary)
                    }
                } header: {
                    Text("Students")
                }
            }
            .listStyle(.plain)
            .tabItem { Label("Students", systemImage: tag == 1 ? "person.fill" : "person").environment(\.symbolVariants, .none) }
            .tag(1)
            
            // Assignments
            List {
                Section {
                    ForEach(c.assignmentOriginals.sorted { $0.dueDate < $1.dueDate }) { ao in
                        ZStack {
                            Button {
                                router.showScreen(.push) { _ in
                                    GradeAssignmentView(ao: ao, c: c)
                                }
                            } label: {
                                HStack {
                                    VStack {
                                        HStack {
                                            Text(ao.title)
                                            Spacer()
                                            Text(gradedVsNotGraded(assignment: ao))
                                        }
                                        .bold()
                                        HStack {
                                            Text(ao.weight.rawValue)
                                            Spacer()
                                            Text(ao.dueDate, style: .date)
                                        }
                                    }
                                    Image(systemName: "chevron.right")
                                }
                                .padding()
                                .background(
                                    ZStack {
                                        Color(.white)
                                        Color(red: ao.r, green: ao.g, blue: ao.b).opacity(0.375)
                                    }
                                )
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                            }
                            if ao.dueDate.formatted(.dateTime.day().month().year()) == Date.now.formatted(.dateTime.day().month().year()) {
                                Text("Due Today")
                                    .font(.caption)
                                    .padding(5)
                                    .foregroundStyle(.white)
                                    .background(Color.red)
                                    .clipShape(Capsule())
                                    .offset(x: 122.5, y: -35)
                            }
                        }
                        .listRowSeparator(.hidden)
                    }
                } header: {
                    Text("Assignments")
                }
                
            }
            .listStyle(.plain)
            .tabItem { Label("Assignments", systemImage: tag == 2 ? "folder.fill" : "folder").environment(\.symbolVariants, .none) }
            .badge(renderBadge())
            .tag(2)
            
            // Lesson Plans
            List {
                Section {
                    ForEach(c.lessons.sorted { $0.lessonDate < $1.lessonDate }) { l in
                        Button {
                            router.showScreen(.push) { _ in
                                LessonDetailView(lesson: l, c: c)
                            }
                        } label: {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(l.title)
                                        .bold()
                                    Text(l.lessonDate, style: .date)
                                        .foregroundStyle(.secondary)
                                }
                                Spacer()
                                Image(systemName: "chevron.right")
                            }
                        }
                    }
                } header: {
                    Text("Lesson Plans")
                }
            }
            .listStyle(.plain)
            .tabItem { Label("Lesson Plans", systemImage: tag == 3 ? "doc.fill" : "doc").environment(\.symbolVariants, .none) }
            .tag(3)
        }
        .clipped()
        .navigationTitle("\(c.period) - \(c.title)")
//        .toolbar {
//            ToolbarItem(placement: .topBarLeading) {
//                Button {
//                    router.dismissScreen()
//                } label: {
//                    Image(systemname: "chevron.left")
//                }
//            }
//        }
        .toolbar {
        
                Menu {
                    Button("Class Settings", systemImage: "gearshape") {
                        router.showScreen(.sheet) { _ in
                            EditClassView(c: c)
                        }
                    }
                    Divider()
                    Button("New Student", systemImage: "person") {
                        router.showScreen(.sheet) { _ in
                            AddStudentView(c: c)
                        }
                    }
                    Button("New Assignment", systemImage: "folder") {
                        router.showScreen(.sheet) { _ in
                            AddAssignmentView(c: c)
                        }
                    }
                    Button("New Lesson Plan", systemImage: "doc") {
                        router.showScreen(.sheet) { _ in
                            AddLessonView(c: c)
                        }
                    }
                    Divider()
                    Button("Delete All Assignments", systemImage: "trash", role: .destructive) {
                        showDeleteAssignmentsAlert.toggle()
                    }
                    Button("Delete Class", systemImage: "trash", role: .destructive) {
                        showDeleteClassAlert.toggle()
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
        .alert("Are you sure you want to delete this class?", isPresented: $showDeleteClassAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                modelContext.delete(c)
                router.dismissScreen()
            }
        }
        .alert("Are you sure you want to delete this class's assignments?", isPresented: $showDeleteAssignmentsAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                c.assignmentOriginals.removeAll()
                c.students.forEach { s in
                    s.assignments.removeAll()
                }
            }
        }
        .navigationBarBackButtonHidden()
    }
    func gradedVsNotGraded(assignment: AssignmentOriginal) -> String {
        var totalAssigned = 0
        var totalGraded = 0
        c.students.forEach { student in
            student.assignments.forEach { a in
                if a.title == assignment.title {
                    totalAssigned += 1
                }
                if a.title == assignment.title && !a.grade.isEmpty {
                    totalGraded += 1
                }
            }
        }
        return "\(totalGraded)/\(totalAssigned)"
    }
    func renderBadge() -> Int {
        var badgeCount = 0
        c.assignmentOriginals.forEach { ao in
            if ao.dueDate.formatted(.dateTime.day().month().year()) == Date.now.formatted(.dateTime.day().month().year()) {
                badgeCount += 1
            }
        }
        return badgeCount
    }
    
}






//#Preview {
//    ClassDetailView()
//}
