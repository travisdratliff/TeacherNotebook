//
//  NewCourseView.swift
//  TeacherNotebook2
//
//  Created by Travis Domenic Ratliff on 3/21/26.
//

import SwiftUI
import SwiftData

struct NewCourseView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    @Environment(\.colorScheme) var scheme
    @State var title = ""
    @State var period: Int? = nil
    @State var metricTitle = ""
    @State var metricTitleList = [String]()
    var buttonIsValid: Bool {
        !title.trimmed().isEmpty && period != nil
    }
    var body: some View {
        NavigationStack {
            List {
                Section {
                    TextField("Title", text: $title)
                    TextField("Period", value: $period, format: .number)
                        .keyboardType(.numberPad)
                } header: {
                    
                }
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
                        .disabled(metricTitle.trimmed().isEmpty)
                    }
                    .padding(.horizontal)
                    .listRowInsets(EdgeInsets())
                    ForEach(metricTitleList, id: \.self) { metric in
                        Text(metric)
                    }
                } header: {
                    Text("data metrics")
                }
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
        let metrics = metricTitleList.map { Metric(title: $0) }
        let course = Course(title: title, period: period ?? 0, metrics: metrics)
        modelContext.insert(course)
    }
}

//#Preview {
//    NewClassView()
//}
