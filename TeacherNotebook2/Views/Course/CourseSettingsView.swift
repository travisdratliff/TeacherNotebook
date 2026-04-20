//
//  CourseSettingsView.swift
//  TeacherNotebook2
//
//  Created by Travis Domenic Ratliff on 4/12/26.
//

import SwiftUI
import SwiftData

struct CourseSettingsView: View {
    
    @Query var courses: [Course]
    
    @Bindable var course: Course
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    @Environment(\.colorScheme) var scheme
    
    @State var showAlert = false
    
    var body: some View {
        NavigationStack {
            List {
                // MARK: - Info
                Section {
                    TextField("Title", text: $course.title)
                    TextField("Period", value: $course.period, format: .number)
                        .keyboardType(.numberPad)
                    TextField("Lowest Passing Grade", value: $course.passingGrade, format: .number)
                        .keyboardType(.decimalPad)
                } header: {
                    Text("info")
                }
                // MARK: - Data
                Section {
                    ForEach($course.metrics, id: \.self) { $metric in
                        TextField(metric.title, text: $metric.title)
                    }
                } header: {
                    Text("data metrics")
                }
                // MARK: - Save
                Section {
                    HStack {
                        Spacer()
                        Button {
                            guard !courses.contains(where: { course.period == $0.period}) else {
                                showAlert = true
                                course.period = 1
                                return
                            }
                            try? modelContext.save()
                            dismiss()
                        } label: {
                            Text("Save")
                                .saveButtonModifier(scheme: scheme)
                        }
                        .disabled(validate())
                        .buttonStyle(.borderless)
                    }
                    .listRowBackground(Color.clear)
                }
            }
            // MARK: - Modifiers
            .navigationTitle("New Class")
            .navigationBarBackButtonHidden(true)
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
            .alert("Conflicting Period", isPresented: $showAlert) {
                Button("Ok", role: .cancel) { }
            } message: {
                Text("There is another course with the same period. Please enter a different period")
            }
        }
    }
    func validate() -> Bool {
        return !course.title.trimmed().isEmpty && !course.passingGrade.isNaN && !course.metrics.isEmpty && !course.metrics.contains(where: { $0.title.trimmed().isEmpty }) && !course.period.words.isEmpty
    }
}

//#Preview {
//    CourseSettingsView()
//}
