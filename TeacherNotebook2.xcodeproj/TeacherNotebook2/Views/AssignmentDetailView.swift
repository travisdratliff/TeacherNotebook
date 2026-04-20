//
//  AssignmentDetailView.swift
//  TeacherNotebook2
//
//  Created by Travis Domenic Ratliff on 3/21/26.
//

import SwiftUI
import SwiftData

struct AssignmentDetailView: View {
    @Binding var path: NavigationPath
    @Bindable var assignment: Assignment
    @State var sortedGrades = [Grade]()
    var body: some View {
        List {
            Section {
                ForEach(sortedGrades) { grade in
                    if let index = assignment.grades.firstIndex(where: { $0.student == grade.student }) {
                        HStack {
                            Text("\(grade.student.lastName), \(grade.student.firstName)")
                            Spacer()
                            TextField("", value: $assignment.grades[index].score, format: .number)
                                .frame(width: 50)
                                .keyboardType(.decimalPad)
                                .textFieldStyle(.roundedBorder)
                        }
                    }
                }
            } header: {
                Text("grades")
            }
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
                    Text("Metric:")
                    Spacer()
                    if let metric = assignment.metric {
                        Text("\(metric.title)")
                    }
                }
            } header: {
                Text("data")
            }
        }
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
                    Image(systemName: "rectangle.portrait.fill")
                        .foregroundStyle(Color(red: assignment.weight!.red, green: assignment.weight!.green, blue: assignment.weight!.blue))
                    Text(assignment.title)
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    
                } label: {
                    Image(systemName: "gearshape")
                }
            }
        }
        .onAppear {
            sortedGrades = assignment.grades.sorted(by: { $0.student.lastName < $1.student.lastName })
        }
    }
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
}

//#Preview {
//    AssignmentDetailView()
//}
