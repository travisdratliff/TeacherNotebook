//
//  AssignmentDetailView.swift
//  TeacherNotebook2
//
//  Created by Travis Domenic Ratliff on 3/21/26.
//

import SwiftUI
import SwiftData
import Charts

struct AssignmentDetailView: View {
    //
    @Binding var path: NavigationPath
    //
    @Bindable var assignment: Assignment
    //
    var body: some View {
    // MARK: - Filter Students
        let sortedGrades = assignment.grades.sorted(by: { $0.student.lastName < $1.student.lastName })
    // MARK: - Grade Inputs
        List {
            Section {
                ForEach(sortedGrades) { grade in
                    if let index = assignment.grades.firstIndex(where: { $0.student == grade.student }) {
                        HStack {
                            Text("\(grade.student.lastName), \(grade.student.firstName)")
                            Spacer()
                            // fix this to be closed range 0...100 if teacher inputs outside of range accidentally
                            TextField("Score", value: $assignment.grades[index].score, format: .number)
                                .frame(width: 70)
                                .keyboardType(.decimalPad)
                                .textFieldStyle(.roundedBorder)
                        }
                    }
                }
            } header: {
                Text("grades")
            }
    // MARK: - Data
            Section {
                HStack {
                    Text("Class Average:")
                    Spacer()
                    if let avg = findClassAverage() {
                        Text("\(String(format: "%.2f", avg))")
                    } else {
                        Text("--")
                    }
                }
                HStack {
                    Text("Range:")
                    Spacer()
                    if let lowest = findRange().min, let highest = findRange().max {
                        Text("\(String(format: "%.2f", lowest)) ... \(String(format: "%.2f", highest))")
                    }
                }
                HStack {
                    Text("Metric:")
                    Spacer()
                    if let metric = assignment.metric {
                        Text("\(metric.title)")
                    }
                }
                GroupBox("Percent Passing / Failing") {
                    Chart {
                        SectorMark(
                            angle: .value("Passing", sortPercentPassing().passing),
                            innerRadius: .ratio(0.5)
                        )
                        .foregroundStyle(.green)
                        .annotation(position: .overlay) {
                            Text("\(String(format: "%.2f", sortPercentPassing().passing))%")
                        }
                        SectorMark(
                            angle: .value("Failing", sortPercentPassing().failing),
                            innerRadius: .ratio(0.5)
                        )
                        .foregroundStyle(.red)
                        .annotation(position: .overlay) {
                            Text(
                                sortPercentPassing().failing == 0.0 ? "" : "\(String(format: "%.2f", sortPercentPassing().failing))%"
                            )
                        }
                    }
                    .frame(height: 250)
                }
            } header: {
                Text("data")
            }
        }
    // MARK: - View Modifiers
        .navigationTitle("\(assignment.title)")
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
                HStack {
                    if let weight = assignment.weight {
                        Image(systemName: "rectangle.portrait.fill")
                            .foregroundStyle(Color(red: weight.red, green: weight.green, blue: weight.blue))
                        Text(assignment.title)
                    }
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    
                } label: {
                    Image(systemName: "gearshape")
                }
            }
        }
    }
    // MARK: - View Functions
    func findClassAverage() -> Double? {
        var amount = 0.0
        var notNil = 0
        for grade in assignment.grades {
            amount += grade.score ?? 0.0
            if grade.score != nil {
                notNil += 1
            }
        }
        if notNil == 0 {
            return nil
        } else {
            return amount / Double(notNil)
        }
    }
    func findRange() -> (min: Double?, max: Double?) {
        let range = assignment.grades.compactMap(\.score)
        let lowest = range.min()
        let highest = range.max()
        return (lowest, highest)
    }
    func sortPercentPassing() -> (passing: Double, failing: Double) {
        let grades = assignment.grades.compactMap(\.score)
        let passing = grades.filter { $0 >= 70 }.count
        let failing = grades.filter { $0 < 70 }.count
        let percentPassing = Double(passing) / Double(grades.count) * 100
        let percentFailing = Double(failing) / Double(grades.count) * 100
        return (percentPassing, percentFailing)
    }
}

//#Preview {
//    AssignmentDetailView()
//}
