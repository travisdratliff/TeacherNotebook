//
//  NewStudentView.swift
//  TeacherNotebook2
//
//  Created by Travis Domenic Ratliff on 3/21/26.
//

import SwiftUI
import SwiftData

struct NewStudentView: View {
    @Bindable var course: Course
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    @Environment(\.colorScheme) var scheme
    @State var firstName = ""
    @State var lastName = ""
    @State var id = ""
    @State var showDuplicateIdAlert = false
    var saveIsValid: Bool {
        !firstName.trimmed().isEmpty && !lastName.trimmed().isEmpty && !id.trimmed().isEmpty
    }
    var body: some View {
        NavigationStack {
            List {
                Section {
                    TextField("First Name", text: $firstName)
                    TextField("Last Name", text: $lastName)
                    TextField("ID (in case of duplicate names)", text: $id)
                        .keyboardType(.numberPad)
                }
                Section {
                    HStack {
                        Spacer()
                        Button {
                            saveStudent()
                        } label: {
                            Text("Save")
                                .saveButtonModifier(scheme: scheme)
                        }
                        .buttonStyle(.borderless)
                        .disabled(!saveIsValid)
                    }
                    .listRowBackground(Color.clear)
                }
            }
            .navigationTitle("New Student")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "minus")
                    }
                    .tint(.primary)
                }
            }
            .alert("Duplicate ID", isPresented: $showDuplicateIdAlert) {
                Button("Ok", role: .cancel) { }
            } message: {
                Text("The ID for this student is already associated with another student in this course.")
            }
        }
    }
    func saveStudent() {
        let student = Student(id: id, firstName: firstName, lastName: lastName)
        let seat = Seat(id: student.id, firstName: student.firstName, lastName: student.lastName)
        guard !course.students.contains(where: { $0.id == student.id }) else {
            showDuplicateIdAlert.toggle()
            id = ""
            return
        }
        course.students.append(student)
        course.seats.append(seat)
        if !course.assignments.isEmpty {
            for assignment in course.assignments {
                if let unwrappedWeight = assignment.weight {
                    let grade = Grade(weight: unwrappedWeight, student: student)
                    assignment.grades.append(grade)
                }
            }
        }
        try? modelContext.save()
        dismiss()
    }
}

//#Preview {
//    NewStudentView()
//}
