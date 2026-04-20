//
//  NewCourseView.swift
//  TeacherNotebook2
//
//  Created by Travis Domenic Ratliff on 3/21/26.
//

import SwiftUI
import SwiftData

struct NewCourseView: View {
    
    @Query var course: [Course]
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    @Environment(\.colorScheme) var scheme
    
    @State var title = ""
    @State var period: Int? = nil
    @State var metricTitle = ""
    @State var metricTitleList = [String]()
    @State var passingGrade: Double? = nil
    @State var showAlert = false
    
    var buttonIsValid: Bool {
        !title.isEmpty && period != nil && passingGrade != nil
    }
    var body: some View {
        NavigationStack {
            List {
                // MARK: - Info
                Section {
                    TextField("Title", text: $title)
                    TextField("Period", value: $period, format: .number)
                        .keyboardType(.numberPad)
                    TextField("Lowest Passing Grade", value: $passingGrade, format: .number)
                        .keyboardType(.decimalPad)
                } header: {
                    Text("info")
                }
                // MARK: - Metrics
                Section {
                    HStack {
                        TextField("Metric", text: $metricTitle)
                        Spacer()
                        Button {
                            guard !metricTitleList.contains(metricTitle.trimmed()) else {
                                metricTitle = ""
                                return
                            }
                            metricTitleList.append(metricTitle.trimmed())
                            metricTitle = ""
                        } label: {
                            Image(systemName: "plus.circle.fill")
                                .font(.largeTitle)
                                .plusButtonModifer(scheme: scheme)
                        }
                        .buttonStyle(.borderless)
                        .disabled(metricTitle.isEmpty)
                    }
                    .padding(.horizontal)
                    .listRowInsets(EdgeInsets())
                    ForEach(metricTitleList, id: \.self) { metric in
                        Text(metric)
                            .swipeActions(edge: .trailing) {
                                Button("Delete", role: .destructive) {
                                    if let index = metricTitleList.firstIndex(of: metric) {
                                        metricTitleList.remove(at: index)
                                    }
                                }
                                .tint(.red)
                            }
                    }
                } header: {
                    Text("data metrics")
                }
                // MARK: - Save
                Section {
                    HStack {
                        Spacer()
                        Button {
                            saveCourse()
                            dismiss()
                        } label: {
                            Text("Save")
                                .saveButtonModifier(scheme: scheme)
                        }
                        .disabled(!buttonIsValid)
                        .buttonStyle(.borderless)
                    }
                    .listRowBackground(Color.clear)
                }
            }
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
        }
    }
    func saveCourse() {
        if let period, let passingGrade {
            let metrics = metricTitleList.map { Metric(title: $0) }
            let course = Course(title: title, period: period, metrics: metrics)
            course.passingGrade = passingGrade
            modelContext.insert(course)
        }
    }
}

//#Preview {
//    NewClassView()
//}
