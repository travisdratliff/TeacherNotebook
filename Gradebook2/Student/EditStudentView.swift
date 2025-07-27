//
//  EditStudentView.swift
//  Gradebook2
//
//  Created by Travis Domenic Ratliff on 1/25/25.
//

import SwiftUI
import SwiftData
import SwiftfulRouting

struct EditStudentView: View {
    
    @Environment(\.router) var router
    @Environment(\.modelContext) var modelContext
    
    var c: Class
    var s: Student
    
    @State var firstName = ""
    @State var lastName = ""
    @State var gradeLevel = ""
    @State var id = ""
    var isValid: Bool {
        !firstName.trim().isEmpty && !lastName.trim().isEmpty && !gradeLevel.isEmpty && !id.isEmpty
    }
    
    var body: some View {
        List {
            TextField("First Name", text: $firstName)
            TextField("Last Name", text: $lastName)
            TextField("Grade Level", text: $gradeLevel)
                .keyboardType(.numberPad)
            TextField("ID", text: $id)
                .keyboardType(.numberPad)
        }
        .listStyle(.plain)
        .navigationTitle("Edit Student")
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button("", systemImage: "minus") {
                    router.dismissScreen()
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button("", systemImage: "checkmark") {
                    let oldId = s.id
                    let newId = id
                    guard c.students.contains(where: { $0.id == newId && $0.id != oldId }) else {
                        c.students.forEach { s in
                            if s.id == oldId {
                                s.firstName = firstName
                                s.lastName = lastName
                                s.gradeLevel = gradeLevel
                                s.id = newId
                                s.assignments.forEach { a in
                                    a.firstName = firstName
                                    a.lastName = lastName
                                    a.fullName = lastName + firstName
                                }
                            }
                        }
                        do {
                            try modelContext.save()
                        } catch {
                            print(error.localizedDescription)
                        }
                        router.dismissScreen()
                        return
                    }
                    router.showBasicAlert(text: "There is already a student with this ID in this class") {
                        id = oldId
                    }
                }
                .disabled(!isValid)
            }
        }
        .onAppear {
            firstName = s.firstName
            lastName = s.lastName
            gradeLevel = s.gradeLevel
            id = s.id
        }
    }
}

//#Preview {
//    EditStudentView()
//}
