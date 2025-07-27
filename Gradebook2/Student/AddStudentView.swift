//
//  AddStudentView.swift
//  Gradebook2
//
//  Created by Travis Domenic Ratliff on 1/19/25.
//

import SwiftUI
import SwiftData
import SwiftfulRouting

struct AddStudentView: View {
    
    @Environment(\.router) var router
    @Environment(\.modelContext) var modelContext
    
    var c: Class
    @State var firstName = ""
    @State var lastName = ""
    @State var gradeLevel = ""
    @State var id = ""
    var isValid: Bool {
        !firstName.trim().isEmpty && !lastName.trim().isEmpty && !gradeLevel.isEmpty && !id.isEmpty
    }
    
    var body: some View {
        List {
            Section {
                TextField("First Name", text: $firstName)
                TextField("Last Name", text: $lastName)
                TextField("Grade Level", text: $gradeLevel)
                    .keyboardType(.numberPad)
                TextField("ID", text: $id)
                    .keyboardType(.numberPad)
            } header: {
                Text("Details")
            }
        }
        .listStyle(.plain)
        .navigationTitle("New Student")
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button("", systemImage: "minus") {
                    router.dismissScreen()
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button("", systemImage: "plus") {
                    if c.students.contains(where: { $0.id == id }) {
                        router.showBasicAlert(text: "There is already a student with this ID in this class") {
                            id = ""
                        }
                    } else {
                        let student = Student(firstName: firstName.trim(), lastName: lastName.trim(), id: id, gradeLevel: gradeLevel)
                        c.students.append(student)
                        if let index = c.students.firstIndex(of: student) {
                            if c.assignmentOriginals.count != 0 {
                                c.assignmentOriginals.forEach { ao in
                                    let a = Assignment(title: ao.title, weight: ao.weight, grade: "", fullName: student.fullName, dueDate: ao.dueDate)
                                    a.firstName = student.firstName
                                    a.lastName = student.lastName
                                    c.students[index].assignments.append(a)
                                }
                            }
                        }
                        do {
                            try modelContext.save()
                        } catch {
                            print(error.localizedDescription)
                        }
                        router.dismissScreen()
                    }
                }
                .disabled(!isValid)
            }
        }
    }
}

//#Preview {
//    AddStudentView()
//}
