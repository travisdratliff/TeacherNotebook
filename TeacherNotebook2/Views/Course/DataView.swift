//
//  DataView.swift
//  TeacherNotebook2
//
//  Created by Travis Domenic Ratliff on 3/21/26.
//

import SwiftUI
import SwiftData
import Charts

@MainActor
struct DataView: View {
    //
    @Binding var path: NavigationPath
    //
    @Environment(\.colorScheme) var scheme
    //
    @Query(sort: \GradingPeriod.startDate) var gradingPeriods: [GradingPeriod]
    @Query(sort: \GradingWeight.percentage) var gradingWeights: [GradingWeight]
    //
    @Bindable var course: Course
    //
    @State var pdfURL: URL? = nil
    var body: some View {
        DataForPDFView(path: path, course: course, scheme: scheme, gradingPeriods: gradingPeriods, gradingWeights: gradingWeights)
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
                    ShareLink(item: pdfURL ?? URL.documentsDirectory) {
                        HStack {
                            Text("Export Data PDF")
                            Image(systemName: "square.and.arrow.up")
                        }
                    }
                    Button("Export All Data as CSV") {
                        
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                }
                .tint(.primary)
            }
        }
        .onAppear {
            pdfURL = exportToPDF(renderImage())
        }
    }
    // produces blank pdf, fix this
    func exportToPDF<V: View>(_ view: V) -> URL? {
        let renderer = ImageRenderer(content: view)
        let url = URL.documentsDirectory.appending(path: "Data\(course.title).pdf")
        renderer.render { size, context in
            var box = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            guard let pdfContext = CGContext(url as CFURL, mediaBox: &box, nil) else { return }
            pdfContext.beginPDFPage(nil)
            context(pdfContext)
            pdfContext.endPDFPage()
            pdfContext.closePDF()
        }
        return url
    }
    @ViewBuilder
    func renderImage() -> some View {
        DataForPDFView(path: path, course: course, scheme: scheme, gradingPeriods: gradingPeriods, gradingWeights: gradingWeights)
    }
}

struct DataForPDFView: View {
    var path: NavigationPath
    var course: Course
    var scheme: ColorScheme
    var gradingPeriods: [GradingPeriod]
    var gradingWeights: [GradingWeight]
    var body: some View {
        List {
            Group {
                GroupBox("Percent Passing Per Weight") {
                    Chart(gradingWeights) { weight in
                        BarMark(
                            x: .value("Weight", weight.title),
                            y: .value("Amount passing", DataCalculator.amountPassingPerCategory(weight: weight, course: course))
                        )
                        .foregroundStyle(Color(red: weight.red, green: weight.green, blue: weight.blue))
                        .annotation(position: .top) {
                            Text("\(String(format: "%.2f", DataCalculator.amountPassingPerCategory(weight: weight, course: course)))%")
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
                        BarMark(x: .value("Passing", "Passing"), y: .value("Amount", DataCalculator.amountPassingByAverage(course: course)))
                            .foregroundStyle(.green)
                            .annotation(position: .top) {
                                Text("\(String(format: "%.2f", DataCalculator.amountPassingByAverage(course: course)))%")
                                    .font(.caption)
                            }
                        BarMark(x: .value("Failing", "Failing"), y: .value("Amount", 100.00 - DataCalculator.amountPassingByAverage(course: course)))
                            .foregroundStyle(.red)
                            .annotation(position: .top) {
                                Text("\(String(format: "%.2f", 100 - DataCalculator.amountPassingByAverage(course: course)))%")
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
                            x: .value("Percent Passing", DataCalculator.percentPassingMetric(metric: metric, course: course)),
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
                            Text("\(String(format: "%.2f", DataCalculator.percentPassingMetric(metric: metric, course: course)))%")
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
                            x: .value("Average Score", DataCalculator.averageGradePerMetric(metric: metric, course: course)),
                            y: .value("Metric", metric.title)
                        )
                        .foregroundStyle(
                            .linearGradient(Gradient(colors: [Color(red: scheme == .dark ? 0.71 : 1, green: scheme == .dark ? 0.55 : 0.8, blue: scheme == .dark ? 0.82 : 0.68), Color(red: scheme == .dark ? 0.58 : 1, green: scheme == .dark ? 0.39 : 0.6, blue: scheme == .dark ? 0.73 : 0.59)]),
                                            startPoint: .top,
                                            endPoint: .bottom
                                           )
                        )
                        .annotation(position: .overlay) {
                            Text("\(String(format: "%.2f", DataCalculator.averageGradePerMetric(metric: metric, course: course)))%")
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
                            if let avg = DataCalculator.findClassAverage(assignment: assignment), assignment.metric == metric {
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
    }
}

//#Preview {
//    DataView()
//}
