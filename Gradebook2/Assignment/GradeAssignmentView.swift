//
//  GradeAssignmentView.swift
//  Gradebook2
//
//  Created by Travis Domenic Ratliff on 1/21/25.
//

import SwiftUI
import SwiftData
import SwiftfulRouting

struct GradeAssignmentView: View {
    
    @Environment(\.router) var router
    @Environment(\.modelContext) var modelContext
    
    var ao: AssignmentOriginal
    var c: Class
    
    @State var grade = ""
    @State var assignments = [Assignment]()
    @State var showAlert = false
    
    var body: some View {
        List {
            Section {
                ForEach($assignments) { $a in
                    HStack {
                        Text("\(a.lastName), \(a.firstName)")
                        Spacer()
                        TextField("Grade", text: $a.grade)
                            .textFieldStyle(.roundedBorder)
                            .multilineTextAlignment(.center)
                            .keyboardType(.numberPad)
                            .frame(width: 65)
                    }
                }
            } header: {
                Text("Students")
            }
        }
        .listStyle(.plain)
        .navigationTitle(ao.title)
        .toolbar {
            Menu {
                Button("Assignment Settings", systemImage: "gearshape") {
                    router.showScreen(.sheet) { _ in
                        EditAssignmentView(ao: ao, c: c)
                    }
                }
                Divider()
                Button("All 100%", systemImage: "pencil") {
                    assignments.forEach { a in
                        a.grade = "100"
                    }
                }
                .disabled(c.students.isEmpty)
                Button("All 0%", systemImage: "pencil") {
                    assignments.forEach { a in
                        a.grade = "0"
                    }
                }
                .disabled(c.students.isEmpty)
                Button("All Clear", systemImage: "eraser") {
                    assignments.forEach { a in
                        a.grade = ""
                    }
                }
                .disabled(c.students.isEmpty)
                Divider()
                Button("Delete Assignment", systemImage: "trash", role: .destructive) {
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
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarBackground(Color(red: ao.r, green: ao.g, blue: ao.b).opacity(0.375), for: .navigationBar)
        .onAppear {
            assignments = fetchAssignments()
        }
        .alert("Are you sure you want to delete this assignment?", isPresented: $showAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                let oldTitle = ao.title
                if let index = c.assignmentOriginals.firstIndex(of: ao) {
                    c.assignmentOriginals.remove(at: index)
                }
                c.students.forEach { s in
                    if let index = s.assignments.firstIndex(where: { $0.title == oldTitle }) {
                        s.assignments.remove(at: index)
                    }
                }
                router.dismissScreen()
            }
        }
        .navigationBarBackButtonHidden()
    }
    func fetchAssignments() -> [Assignment] {
        var array = [Assignment]()
        for s in c.students {
            for a in s.assignments {
                if a.title == ao.title {
                    array.append(a)
                }
            }
        }
        return array.sorted { $0.fullName < $1.fullName }
    }
}

//#Preview {
//    GradeAssignmentView()
//}
