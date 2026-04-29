//
//  StudentDetailView.swift
//  TeacherNotebook2
//
//  Created by Travis Domenic Ratliff on 3/21/26.
//

import SwiftUI
import SwiftData
import Charts

struct StudentDetailView: View {
    //
    @Query(sort: \GradingPeriod.startDate) var gradingPeriods: [GradingPeriod]
    @Query(sort: \GradingWeight.percentage) var weights: [GradingWeight]
    //
    @Environment(\.modelContext) var modelContext
    @Environment(\.colorScheme) var scheme
    //
    @Binding var path: NavigationPath
    @Bindable var student: Student
    @Bindable var course: Course
    //
    @State var pickedGradingPeriod: GradingPeriod?
    @State var pdfURL: URL?
    //
    var body: some View {
        let studentAverage = DataCalculator.calculateStudentAverage(student: student, course: course)
        let studentAssignments = course.assignments.sorted { $0.dueDate < $1.dueDate }.filter { $0.grades.contains(where: { $0.student == student})}
        List {
            Section {
                HStack {
                    Text("Class Average:")
                    Spacer()
                    Text(String(format: "%.2f", studentAverage.classAverage))
                }
                ForEach(Array(studentAverage.percentages), id: \.key) { weight, grades in
                    HStack {
                        Text("\(weight.title) Average:")
                        Spacer()
                        Text(String(format: "%.2f", grades.reduce(0.0, +) / Double(grades.count)))
                    }
                }
            } header: {
                Text("averages")
            }
            Section {
                Picker("Select Grading Period", selection: $pickedGradingPeriod) {
                    ForEach(gradingPeriods) { period in
                        Text(period.title).tag(period as GradingPeriod?)
                    }
                }
                .pickerStyle(.segmented)
                ForEach(studentAssignments, id: \.id) { assignment in
                    if let period = pickedGradingPeriod, (period.startDate...period.endDate).contains(assignment.dueDate) {
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
                                    if let score = DataCalculator.findStudentGrade(assignment: assignment, student: student) {
                                        Text(String(format: "%.2f", score))
                                            .frame(width: 50)
                                    } else {
                                        Text("--")
                                            .frame(width: 50)
                                    }
                                }
                            }
                        }
                    }
                }
            } header: {
                Text("grades")
            }
            Section {
                Group {
                    GroupBox("Percent Passing Per Metric") {
                        Chart(course.metrics) { metric in
                            BarMark(
                                x: .value("Percent Passing", DataCalculator.percentStudentPassingMetric(student: student, metric: metric, course: course)),
                                y: .value("Metric", metric.title)
                            )
                            .foregroundStyle(
                                .linearGradient(Gradient(colors: [Color(red: scheme == .dark ? 0.71 : 1, green: scheme == .dark ? 0.55 : 0.8, blue: scheme == .dark ? 0.82 : 0.68), Color(red: scheme == .dark ? 0.58 : 1, green: scheme == .dark ? 0.39 : 0.6, blue: scheme == .dark ? 0.73 : 0.59)]),
                                                startPoint: .top,
                                                endPoint: .bottom
                                               )
                            )
                            .annotation(position: .overlay) {
                                Text("\(String(format: "%.2f", DataCalculator.percentStudentPassingMetric(student: student, metric: metric, course: course)))%")
                                    .font(.caption)
                                    .foregroundStyle(.primary)
                            }
                        }
                        .frame(height: CGFloat(course.metrics.count) * 60)
                        .chartXScale(domain: 0...100)
                        .padding(.top)
                    }
                    .padding(.bottom)
                    ForEach(course.metrics) { metric in
                        GroupBox("\(metric.title) - timeline") {
                            Chart(studentAssignments.sorted { $0.dueDate < $1.dueDate }) { assignment in
                                if let grade = DataCalculator.findStudentGrade(assignment: assignment, student: student), assignment.metric == metric {
                                    LineMark(
                                        x: .value("", assignment.dueDate),
                                        y: .value(metric.title, grade)
                                    )
                                    PointMark(
                                        x: .value("", assignment.dueDate),
                                        y: .value("", grade)
                                    )
                                    .annotation(position: .top) {
                                        Text(String(format: "%.2f", grade))
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
            } header: {
                Text("Student Data")
            }
        }
        .navigationTitle("\(student.lastName), \(student.firstName)")
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
            ToolbarItem(placement: .topBarTrailing) {
                Menu {
                    Button("Student Settings") { }
//                    ShareLink("Export All Data as PDF", item: pdfURL ?? render(label: student.fullName))
                    Divider()
                    Button("Delete Student", role: .destructive) {
                        deleteStudent(student: student)
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                }
                .tint(.primary)
            }
        }
        .onAppear {
            for period in gradingPeriods {
                if (period.startDate...period.endDate).contains(Date.now) {
                    pickedGradingPeriod = period
                }
            }
            if pickedGradingPeriod == nil {
                pickedGradingPeriod = gradingPeriods.first
            }
        }
    }
//    func render() -> URL {
//        let renderer = ImageRenderer(content: self)
//        let url = URL.documentsDirectory.appending(path: "\(course.title)-\(student.fullName)data.pdf")
//        renderer.render { size, context in
//            var box = CGRect(x: 0, y: 0, width: size.width, height: size.height)
//            guard let pdf = CGContext(url as CFURL, mediaBox: &box, nil) else { return }
//            pdf.beginPDFPage(nil)
//            context(pdf)
//            pdf.endPDFPage()
//            pdf.closePDF()
//        }
//        return url
//    }
    func deleteStudent(student: Student) {
        modelContext.delete(student)
        for seat in course.seats {
            if seat.id == student.id {
                modelContext.delete(seat)
            }
        }
        for assignment in course.assignments {
            if let index = assignment.grades.firstIndex(where: { $0.student == student }) {
                assignment.grades.remove(at: index)
            }
        }
        try? modelContext.save()
        path.removeLast()
    }
}

//#Preview {
//    StudentDetailView()
//}
