//
//  StudentDetailView.swift
//  Gradebook2
//
//  Created by Travis Domenic Ratliff on 1/19/25.
//

import SwiftUI
import SwiftData
import SwiftfulRouting

struct StudentDetailView: View {
    
    @Environment(\.router) var router
    @Environment(\.modelContext) var modelContext
    
    var s: Student
    var c: Class
    
    @State var tag = 1
    @State var studentAssignments = [Assignment]()
    @State var showAlert = false
    
    var body: some View {
        TabView(selection: $tag) {
            List {
                Section {
                    ForEach(s.assignments.sorted { $0.dueDate < $1.dueDate }, id: \.self) { a in
                        ZStack {
                            VStack {
                                HStack {
                                    Text(a.title)
                                    Spacer()
                                    Text(a.grade.isEmpty ? "No grade" : a.grade)
                                }
                                .bold()
                                HStack {
                                    Text(a.weight.rawValue)
                                    Spacer()
                                    Text(a.dueDate, style: .date)
                                }
                            }
                            .padding()
                            .background(
                                ZStack {
                                    Color(.white)
                                    Color(red: a.r, green: a.g, blue: a.b).opacity(0.375)
                                }
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            if a.dueDate.formatted(.dateTime.day().month().year()) == Date.now.formatted(.dateTime.day().month().year()) {
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
            .tabItem { Label("Assignments", systemImage: tag == 1 ? "folder.fill" : "folder").environment(\.symbolVariants, .none) }
            .tag(1)
            
            List {
                Section {
                    ForEach(s.notes.sorted { $0.dateWritten < $1.dateWritten }) { n in
                        Button {
                            router.showScreen(.push) { _ in
//                                NoteView(n: n, s: s)
                                EditNoteView(n: n)
                            }
                        } label: {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(n.dateWritten, style: .date)
                                        .bold()
                                    Text(n.content)
                                        .foregroundStyle(.secondary)
                                        .lineLimit(2)
                                        .truncationMode(.tail)
                                }
                                Spacer()
                                Image(systemName: "chevron.right")
                            }
                        }
                    }
                } header: {
                    Text("Student Notes")
                }
            }
            .listStyle(.plain)
            .tabItem { Label("Student Notes", systemImage: "note.text").environment(\.symbolVariants, .none) }
            .tag(2)
        }
        .clipped()
        .navigationTitle("\(s.lastName), \(s.firstName)")
        .toolbar {
            Menu {
                Button("Student Settings", systemImage: "gearshape") {
                    router.showScreen(.sheet) { _ in
                        EditStudentView(c: c, s: s)
                    }
                }
                Divider()
                Button("New Note", systemImage: "note.text") {
                    let note = Note(content: "")
                    router.showScreen(.push) { _ in
//                        AddNoteView(s: s)
                        EditNoteView(n: note)
                    }
                    s.notes.append(note)
                }
                Divider()
                Button("Delete Student", systemImage: "trash", role: .destructive) {
                    showAlert.toggle()
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
        .alert("Are you sure you want to delete this student? All assignments with their name will be removed", isPresented: $showAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                if let index = c.students.firstIndex(of: s) {
                    c.students.remove(at: index)
                }
                do {
                    try modelContext.save()
                } catch {
                    print(error.localizedDescription)
                }
                router.dismissScreen()
            }
        }
        .navigationBarBackButtonHidden()
    }
}

//#Preview {
//    StudentDetailView()
//}
