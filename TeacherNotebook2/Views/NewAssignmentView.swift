//
//  NewAssignmentView.swift
//  TeacherNotebook2
//
//  Created by Travis Domenic Ratliff on 3/23/26.
//

import SwiftUI
import SwiftData

struct NewAssignmentView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var scheme
    @Bindable var course: Course
    @Query(sort: \GradingWeight.percentage) var weights: [GradingWeight]
    @State var title = ""
    @State var weight: GradingWeight?
    @State var assignedDate = Date.now
    @State var dueDate = Date.now
    @State var pickedMetric: Metric?
    var body: some View {
        NavigationStack {
            List {
                Section {
                    TextField("Title", text: $title)
                    Picker("Select Weight", selection: $weight) {
                        ForEach(weights) { weight in
                            Text(weight.title).tag(weight)
                        }
                    }
                    Picker("Select Metric", selection: $pickedMetric) {
                        ForEach(course.metrics) { metric in
                            Text(metric.title).tag(metric)
                        }
                    }
                    DatePicker("Date Assigned", selection: $assignedDate, displayedComponents: .date)
                    DatePicker("Date Due", selection: $dueDate, displayedComponents: .date)
                }
                Section {
                    HStack {
                        Spacer()
                        Button {
                            assign()
                            dismiss()
                        } label: {
                            Text("Add")
                                .saveButtonModifier(scheme: scheme)
                        }
                        .disabled(title.trimmed().isEmpty)
                        .buttonStyle(.borderless)
                    }
                    .listRowBackground(Color.clear)
                }
            }
            .navigationTitle("New Assignment")
            .toolbar {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "minus")
                }
            }
            .onAppear {
                weight = weights[0]
                pickedMetric = course.metrics[0]
            }
        }
    }
    func assign() {
        guard !course.assignments.contains(where: { $0.title == title }) else { return }
        let assignment = Assignment(courseTitle: course.title, title: title.trimmed(), weight: weight!, metric: pickedMetric!, assignedDate: assignedDate, dueDate: dueDate, grades: [])
        for student in course.students {
            if let unwrappedWeight = weight {
                assignment.grades.append(Grade(weight: unwrappedWeight, student: student, score: nil))
            }
        }
        course.assignments.append(assignment)
        SwiftDataManager.save(modelContext: modelContext)
    }
}

//#Preview {
//    NewAssignmentView()
//}
