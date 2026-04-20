//
//  AssignmentListView.swift
//  TeacherNotebook2
//
//  Created by Travis Domenic Ratliff on 3/21/26.
//

import SwiftUI
import SwiftData

struct AssignmentListView: View {
    //
    @Query(sort: \GradingPeriod.startDate) var gradingPeriods: [GradingPeriod]
    @Query(sort: \GradingWeight.percentage) var gradingWeights: [GradingWeight]
    @Query(sort: \Course.period) var courses: [Course]
    //
    @Binding var path: NavigationPath
    //
    @State var pickerGradingWeights = ["All"]
    @State var showNewAssignment = false
    @State var pickedGradingPeriod: GradingPeriod?
    @State var pickedGradingWeight: String?
    //
    var course: Course
    var body: some View {
        // MARK: - Filtered Assignments
        let filteredAssignments = course.assignments.sorted { $0.dueDate < $1.dueDate }.filter { assignment in
            guard let period = pickedGradingPeriod, let weight = assignment.weight else { return false }
            let matchesWeight = pickedGradingWeight == weight.title || pickedGradingWeight == "All"
            let matchesPeriod = (period.startDate...period.endDate).contains(assignment.dueDate)
            return matchesWeight && matchesPeriod
        }
        // MARK: - List
        List {
            Section {
                Picker("Select Grading Period", selection: $pickedGradingPeriod) {
                    ForEach(gradingPeriods) { period in
                        Text(period.title).tag(period)
                    }
                }
                .pickerStyle(.segmented)
                .listRowSeparator(.hidden)
                Picker("Select Grading Weight", selection: $pickedGradingWeight) {
                    ForEach(pickerGradingWeights, id: \.self) { weight in
                        Text(weight).tag(weight)
                    }
                }
                .pickerStyle(.segmented)
                ForEach(filteredAssignments, id: \.id) { assignment in
                    Button {
                        path.append(Route.assignmentDetail(assignment: assignment))
                    } label: {
                        HStack {
                            VStack(alignment: .leading) {
                                HStack {
                                    Image(systemName: "rectangle.portrait.fill")
                                        .foregroundStyle(Color(red: assignment.weight?.red ?? 0.0, green: assignment.weight?.green ?? 0.0, blue: assignment.weight?.blue ?? 0.0))
                                    Text(assignment.title)
                                        .bold()
                                    Spacer()
                                    Text(assignment.dueDate, style: .date)
                                    Divider()
                                    Text("\(checkForNil(assignment: assignment))/\(course.students.count)")
                                    Image(systemName: "chevron.right")
                                        .fontWeight(.thin)
                                }
                            }
                        }
                    }
                    .tint(.primary)
                }
            }
            //            header: {
            //                Text(pickedGradingWeight ?? "All")
            //            }
        }
        // MARK: -
        .navigationTitle("Assignments")
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItemGroup(placement: .topBarLeading) {
                Button {
                    path.removeLast()
                } label: {
                    Image(systemName: "arrow.turn.up.left")
                }
                .tint(.primary)
                Menu {
                    Button("Home") {
                        path.removeLast(path.count)
                    }
                    if courses.count > 1 {
                        Divider()
                        ForEach(courses) { menuCourse in
                            if course.period != menuCourse.period {
                                Button("\(menuCourse.period) - \(menuCourse.title) Assignments") {
                                    Task {
                                        path.removeLast(path.count)
                                        try? await Task.sleep(for: .seconds(0.15))
                                        path.append(Route.courseDetail(course: menuCourse))
                                        try? await Task.sleep(for: .seconds(0.15))
                                        path.append(Route.assignmentList(course: menuCourse))
                                    }
                                }
                            }
                        }
                    }
                } label: {
                    Image(systemName: "arrow.uturn.backward.circle.badge.ellipsis")
                }
            }
            ToolbarItem(placement: .principal) {
                Text(course.title)
                    .foregroundStyle(.secondary)
            }
            ToolbarItem(placement: .topBarTrailing) {
                Menu {
                    Button("New Assignment") { showNewAssignment.toggle() }
                    Menu {
                        Button("Import Assignment") { }
                        Button("Import Template") { }
                    } label: {
                        Text("Import")
                    }
                    Menu {
                        Button("Export Scoresheet") { }
                    } label: {
                        Text("Export")
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                }
                .tint(.primary)
            }
        }
        .sheet(isPresented: $showNewAssignment) {
            NewAssignmentView(course: course)
        }
        .onAppear {
            guard pickedGradingPeriod == nil else { return }
            pickedGradingPeriod = gradingPeriods.first {
                ($0.startDate...$0.endDate).contains(Date.now)
            }
            pickedGradingWeight = pickerGradingWeights[0]
            if pickerGradingWeights.count == 1 {
                pickerGradingWeights.append(contentsOf: gradingWeights.map { $0.title })
            }
        }
    }
    func checkForNil(assignment: Assignment) -> Int {
        var count = 0
        for grade in assignment.grades {
            if grade.score != nil {
                count += 1
            }
        }
        return count
    }
}

struct WeightCategory {
    var category: GradingWeight
    var value: Double
}

//#Preview {
//    AssignmentListView()
//}
