//
//  DataView.swift
//  TeacherNotebook2
//
//  Created by Travis Domenic Ratliff on 3/21/26.
//

import SwiftUI
import SwiftData
import Charts

struct DataView: View {
    @Binding var path: NavigationPath
    @Environment(\.colorScheme) var scheme
    @Query(sort: \GradingPeriod.startDate) var gradingPeriods: [GradingPeriod]
    @Query(sort: \GradingWeight.percentage) var gradingWeights: [GradingWeight]
    var course: Course
    var body: some View {
        List {
            Section {
                Chart(gradingWeights) { weight in
                    BarMark(
                        x: .value("Weight", weight.title),
                        y: .value("Amount passing", amountPassingPerCategory(weight: weight))
                    )
                    .foregroundStyle(Color(red: weight.red, green: weight.green, blue: weight.blue))
                    .annotation(position: .top) {
                        Text("\(String(format: "%.2f", amountPassingPerCategory(weight: weight)))%")
                            .font(.caption)
                    }
                }
                .aspectRatio(1/1, contentMode: .fit)
                .chartYScale(domain: 0...100)
                .padding(.top)
            } header: {
                Text("percent passing per weight")
            }
            Section {
                Chart {
                    BarMark(x: .value("Passing", "Passing"), y: .value("Amount", amountPassingByAverage()))
                        .foregroundStyle(.green)
                        .annotation(position: .top) {
                            Text("\(String(format: "%.2f", amountPassingByAverage()))%")
                                .font(.caption)
                        }
                    BarMark(x: .value("Failing", "Failing"), y: .value("Amount", 100.00 - amountPassingByAverage()))
                        .foregroundStyle(.red)
                        .annotation(position: .top) {
                            Text("\(String(format: "%.2f", 100 - amountPassingByAverage()))%")
                                .font(.caption)
                        }
                }
                .aspectRatio(1/1, contentMode: .fit)
                .chartYScale(domain: 0...100)
                .padding(.top)
            } header: {
                Text("percent passing by class average")
            }
            Section {
                Chart(course.metrics) { metric in
                    BarMark(
                        x: .value("Percent Passing", percentPassingMetric(metric: metric)),
                        y: .value("Metric", metric.title),
                        width: .fixed(20)
                    )
                    .foregroundStyle(
                            .linearGradient(Gradient(colors: [Color(red: scheme == .dark ? 0.71 : 1, green: scheme == .dark ? 0.55 : 0.8, blue: scheme == .dark ? 0.82 : 0.68), Color(red: scheme == .dark ? 0.58 : 1, green: scheme == .dark ? 0.39 : 0.6, blue: scheme == .dark ? 0.73 : 0.59)]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .annotation(position: .overlay) {
                        Text("\(String(format: "%.2f", percentPassingMetric(metric: metric)))%")
                            .font(.caption)
                            .foregroundStyle(.primary)
                    }
                }
                .frame(height: CGFloat(course.metrics.count) * 60)
                .chartXScale(domain: 0...100)
            } header: {
                Text("percent passing per metric")
            }
            Section {
                Chart(course.metrics) { metric in
                    BarMark(
                        x: .value("Average Score", averageGradePerMetric(metric: metric)),
                        y: .value("Metric", metric.title)
                    )
                    .foregroundStyle(
                            .linearGradient(Gradient(colors: [Color(red: scheme == .dark ? 0.71 : 1, green: scheme == .dark ? 0.55 : 0.8, blue: scheme == .dark ? 0.82 : 0.68), Color(red: scheme == .dark ? 0.58 : 1, green: scheme == .dark ? 0.39 : 0.6, blue: scheme == .dark ? 0.73 : 0.59)]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .annotation(position: .overlay) {
                        Text("\(String(format: "%.2f", averageGradePerMetric(metric: metric)))%")
                            .font(.caption)
                            .foregroundStyle(.primary)
                    }
                    RuleMark(x: .value("Passing", 70))
                        .foregroundStyle(.red.opacity(0.8))
                        .lineStyle(StrokeStyle(lineWidth: 1, dash: [5]))
                        .annotation(position: .top, alignment: .leading) {
                            Text("Passing (70%)")
                                .font(.caption)
                                .foregroundStyle(.red)
                        }
                }
                .padding(.top)
                .frame(height: CGFloat(course.metrics.count) * 60)
                .chartXScale(domain: 0...100)
            } header: {
                Text("average score per metric (unweighted)")
            }
            Section {
                ForEach(course.metrics) { metric in
                    GroupBox(metric.title) {
                        Chart(course.assignments.sorted { $0.dueDate < $1.dueDate }) { assignment in
                            if let avg = findClassAverage(assignment: assignment), assignment.metric == metric {
                                LineMark(
                                    x: .value("", assignment.dueDate),
                                    y: .value(metric.title, avg)
                                )
                                PointMark(
                                    x: .value("", assignment.dueDate),
                                    y: .value("", avg)
                                )
                                .annotation(position: .top) {
                                        Text(String(format: "%.2f", avg))
                                            .foregroundStyle(.primary)
                                            .font(.caption)
                                }
                            }
                            RuleMark(y: .value("Passing", 70))
                                .foregroundStyle(.red.opacity(0.8))
                                .lineStyle(StrokeStyle(lineWidth: 1, dash: [5]))
                                .annotation(position: .top, alignment: .leading) {
                                    Text("Passing (70%)")
                                        .font(.caption)
                                        .foregroundStyle(.red)
                                }
                        }
                        .chartYScale(domain: 0...100)
                        .chartXAxisLabel("Due Dates", position: .bottom)
                        .padding(.top)
                    }
                }
                .listRowSeparator(.hidden)
            } header: {
                Text("metrics timeline by assignment average (unweighted)")
            }
        }
        .navigationTitle("Data")
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
            ToolbarItem(placement: .topBarTrailing) {
                Menu {
                    Menu("Export") {
                        Button("Percent Passing by Weight") { }
                        Button("Percent Passing by Grade") { }
                        Button("TimeLine Growth") { }
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                }
                .tint(.primary)
            }
        }
    }
    func amountPassingPerCategory(weight: GradingWeight) -> Double {
        let assignments = course.assignments.filter { $0.weight == weight }
        let grades = assignments.flatMap(\.grades).filter { $0.score != nil }
        guard !grades.isEmpty else { return 0.0 }
        let passing = grades.filter { $0.score ?? 0.0 >= 70 }.count
        return (Double(passing) / Double(grades.count)) * 100
    }
    func amountPassingByAverage() -> Double {
        var amount = 0.0
        guard !course.students.isEmpty else { return 0.0 }
        for student in course.students {
            if calculateAverage(student: student).classAverage >= 70.0 {
                amount += 1
            }
        }
        let total = (amount * 100) / Double(course.students.count)
        return total
    }
    func calculateAverage(student: Student) -> (classAverage: Double, percentages: [GradingWeight: [Double]], hasGrades: Bool) {
        var average = 0.0
        let studentGrades = course.assignments.flatMap(\.grades).filter { $0.student == student }
        let percentagesDictionary = studentGrades.reduce(into: [GradingWeight: [Double]]()) { dictionary, grade in
            if let score = grade.score {
                dictionary[grade.weight, default: []].append(score)
            }
        }
        let totalWeight = percentagesDictionary.keys.map { $0.percentage }.reduce(0.0, +)
        guard totalWeight > 0 else { return (0.0, percentagesDictionary, false) }
        for (weight, grades) in percentagesDictionary {
            let normalizedWeight = weight.percentage / totalWeight
            let avg = (grades.reduce(0.0, +) / Double(grades.count)) * normalizedWeight
            average += avg
        }
        return (average, percentagesDictionary, true)
    }
    func percentPassingMetric(metric: Metric) -> Double {
        var amountPassing = 0.0
        var amountGraded = 0.0
        let assignmentList = course.assignments.filter { $0.metric == metric }.flatMap(\.grades)
        for assignment in assignmentList {
            if assignment.score != nil {
                amountGraded += 1
            }
            if let score = assignment.score {
                if score >= 70 {
                    amountPassing += 1
                }
            }
        }
        guard amountGraded > 0 else { return 0.0 }
        return (amountPassing / amountGraded) * 100
    }
    func averageGradePerMetric(metric: Metric) -> Double {
        var totalScore = 0.0
        var amountGraded = 0.0
        let gradesList = course.assignments.filter { $0.metric == metric }.flatMap(\.grades)
        for grade in gradesList {
            if grade.score != nil {
                amountGraded += 1
            }
            if let score = grade.score {
                totalScore += score
            }
        }
        guard amountGraded > 0 else { return 0.0 }
        return (totalScore / amountGraded)
    }
    func findClassAverage(assignment: Assignment) -> Double? {
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
//    DataView()
//}
