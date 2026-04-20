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
    //
    @Binding var path: NavigationPath
    //
    @Environment(\.colorScheme) var scheme
    //
    @Query(sort: \GradingPeriod.startDate) var gradingPeriods: [GradingPeriod]
    @Query(sort: \GradingWeight.percentage) var gradingWeights: [GradingWeight]
    //
    var course: Course
    //
    var body: some View {
    // MARK: - Data
        List {
            Group {
                GroupBox("Percent Passing Per Weight") {
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
                }
                .padding(.bottom)
                GroupBox("Percent Passing By Class Average") {
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
                }
                .padding(.bottom)
                GroupBox("Percent Passing Per Metric") {
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
                }
                .padding(.bottom)
                GroupBox("Average Score Per Metric (Unweighted)") {
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
                        RuleMark(x: .value("Passing", course.passingGrade))
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
                }
                .padding(.bottom)
    // MARK: - Metric Data
                ForEach(course.metrics) { metric in
                    GroupBox("\(metric.title) - Timeline") {
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
                            RuleMark(y: .value("Passing", course.passingGrade))
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
                    .padding(.bottom)
                }
            }
            .listRowBackground(Color.clear)
            .listRowSeparator(.hidden)
            .listRowInsets(EdgeInsets())
            .backgroundStyle(Color(uiColor: .secondarySystemGroupedBackground))
        }
    // MARK: - View Modifiers
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
                    ShareLink("Export All Data as PDF", item: render())
                    Button("Export All Data as CSV") {
                        
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                }
                .tint(.primary)
            }
        }
    }
    // MARK: - View Functions
    func amountPassingPerCategory(weight: GradingWeight) -> Double {
        let assignments = course.assignments.filter { $0.weight == weight }
        let grades = assignments.flatMap(\.grades).filter { $0.score != nil }
        guard !grades.isEmpty else { return 0.0 }
        let passing = grades.filter { $0.score ?? 0.0 >= course.passingGrade }.count
        return (Double(passing) / Double(grades.count)) * 100
    }
    func amountPassingByAverage() -> Double {
        var amount = 0.0
        guard !course.students.isEmpty else { return 0.0 }
        for student in course.students {
            if calculateAverage(student: student).classAverage >= course.passingGrade {
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
                if score >= course.passingGrade {
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
    func render() -> URL {
        let renderer = ImageRenderer(content:
            VStack {
                Group {
                    GroupBox("Percent Passing Per Weight") {
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
                    }
                    .padding(.bottom)
                    GroupBox("Percent Passing By Class Average") {
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
                    }
                    .padding(.bottom)
                    GroupBox("Percent Passing Per Metric") {
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
                    }
                    .padding(.bottom)
                    GroupBox("Average Score Per Metric (Unweighted)") {
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
                            RuleMark(x: .value("Passing", course.passingGrade))
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
                    }
                    .padding(.bottom)
                    ForEach(course.metrics) { metric in
                        GroupBox("\(metric.title) - Timeline") {
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
                                RuleMark(y: .value("Passing", course.passingGrade))
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
                        .padding(.bottom)
                    }
                }
            }
        )
        let url = URL.documentsDirectory.appending(path: "\(course.title)data.pdf")
        renderer.render { size, context in
            var box = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            guard let pdf = CGContext(url as CFURL, mediaBox: &box, nil) else { return }
            pdf.beginPDFPage(nil)
            context(pdf)
            pdf.endPDFPage()
            pdf.closePDF()
        }
        return url
    }
}

//#Preview {
//    DataView()
//}
