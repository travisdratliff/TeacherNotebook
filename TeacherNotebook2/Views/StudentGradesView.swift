//
//  StudentGradesView.swift
//  TeacherNotebook2
//
//  Created by Travis Domenic Ratliff on 3/25/26.
//

import SwiftUI
import SwiftData

struct StudentGradesView: View {
    @Query(sort: \GradingPeriod.startDate) var gradingPeriods: [GradingPeriod]
    @Query(sort: \GradingWeight.percentage) var gradingWeights: [GradingWeight]
    @State var pickerGradingWeights = ["All"]
    @Binding var path: NavigationPath
    @Bindable var student: Student
    @Bindable var course: Course
    @State var pickedGradingPeriod: GradingPeriod?
    @State var pickedGradingWeight: String?
    var body: some View {
        List {
            Section {
                Picker("Select Grading Period", selection: $pickedGradingPeriod) {
                    ForEach(gradingPeriods) { period in
                        Text(period.title).tag(period)
                    }
                }
                .pickerStyle(.segmented)
                Picker("Select Grading Weight", selection: $pickedGradingWeight) {
                    ForEach(pickerGradingWeights, id: \.self) { weight in
                        Text(weight).tag(weight)
                    }
                }
                .pickerStyle(.segmented)
            }
            .listRowInsets(EdgeInsets())
            .listRowBackground(Color.clear)
            .listRowSeparator(.hidden)
            Section {
                ForEach(course.assignments.sorted { $0.dueDate < $1.dueDate }, id: \.id) { assignment in
                    if (pickedGradingWeight == assignment.weight!.title || pickedGradingWeight == "All") && (pickedGradingPeriod!.startDate...pickedGradingPeriod!.endDate).contains(assignment.dueDate) && assignment.grades.contains(where: { $0.student == student }) {
                        HStack {
                            VStack(alignment: .leading) {
                                HStack {
                                    Image(systemName: "rectangle.portrait.fill")
                                        .foregroundStyle(Color(red: assignment.weight!.red, green: assignment.weight!.green, blue: assignment.weight!.blue))
                                    Text(assignment.title)
                                        .bold()
                                    Spacer()
                                    Text(assignment.dueDate, style: .date)
                                    Divider()
                                    Text(String(format: "%g", findGrade(assignment: assignment)))
                                        .frame(width: 30)
                                }
                            }
                        }
                    }
                }
            } header: {
                Text(pickedGradingWeight ?? "All")
            }
        }
        .navigationTitle("Grades")
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItemGroup(placement: .topBarLeading) {
                Button {
                    path.removeLast()
                } label: {
                    Image(systemName: "arrow.turn.up.left")
                }
                .tint(.primary)
                Button {
                    path.removeLast(path.count)
                } label: {
                    Image(systemName: "house")
                }
                .tint(.primary)
            }
            ToolbarItem(placement: .principal) {
                Text(course.title)
                    .foregroundStyle(.secondary)
            }
        }
        .onAppear {
            guard pickedGradingPeriod == nil else { return }
            pickedGradingPeriod = gradingPeriods.first {
                ($0.startDate...$0.endDate).contains(Date.now)
            }
        }
    }
    func findGrade(assignment: Assignment) -> Double {
        var score = 0.0
        if let index = assignment.grades.firstIndex(where: { $0.student.id == student.id }) {
            score = assignment.grades[index].score ?? 0.0
        }
        return score
    }
}

//#Preview {
//    StudentGradesView()
//}
