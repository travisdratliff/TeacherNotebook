//
//  ContentView.swift
//  TeacherNotebook2
//
//  Created by Travis Domenic Ratliff on 3/21/26.
//

// ADD CUSTOMIZABLE METRIC FOR STUDENT DATA TO TRACK

import SwiftUI
import SwiftData

struct ContentView: View {
    @Query(sort: \Course.period) var courses: [Course]
    //
    @Environment(\.colorScheme) var scheme
    //
    @State var path = NavigationPath()
    @State var calendarMaker = CalendarMaker()
    @State var activeSheet: ContentViewActiveSheet?
    @State var showOnboarding = false
    //
    @AppStorage("Onboarded") var onboarded = false
    //
    @Namespace var zoomCell
    //
    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 7)
    //
    var body: some View {
        NavigationStack(path: $path) {
            List {
                // MARK: - Calendar
                Section {
                    VStack(spacing: 8) {
                        HStack {
                            Button {
                                calendarMaker.changeMonth(by: -1)
                            } label: {
                                Image(systemName: "chevron.left")
                            }
                            Spacer()
                            Text("\(calendarMaker.monthName) \(String(calendarMaker.year))")
                            Spacer()
                            Button {
                                calendarMaker.changeMonth(by: 1)
                            } label: {
                                Image(systemName: "chevron.right")
                            }
                        }
                        .padding()
                        .font(.headline)
                        .foregroundStyle(.primary)
                        .backgroundModifier(scheme: scheme, amount: 50)
                        HStack {
                            ForEach(calendarMaker.shortDays, id: \.self) { day in
                                Text(day)
                                    .frame(maxWidth: .infinity)
                                    .font(.caption)
                                    .bold()
                                    .foregroundStyle(.primary)
                            }
                        }
                        .padding(.vertical)
                        LazyVGrid(columns: columns, spacing: 5) {
                            ForEach(Array(calendarMaker.gridArray.enumerated()), id: \.offset) { _, dayNum in
                                if dayNum == 0 {
                                    Color.clear
                                } else {
                                    let day = Day(
                                        day: dayNum,
                                        month: calendarMaker.month,
                                        year: calendarMaker.year
                                    )
                                    Button {
                                        path.append(Route.dateCell(day: day))
                                    } label: {
                                        CalendarCellView(day: day, holidays: calendarMaker.holidayCache[calendarMaker.year] ?? [])
                                            .matchedTransitionSource(id: day.id, in: zoomCell)
                                    }
                                }
                            }
                        }
                    }
                    .buttonStyle(.borderless)
                }
                // MARK: - Courses
                Section {
                    if courses.isEmpty {
                        emptyRowView(type: "course")
                    } else {
                        ForEach(courses, id: \.id) { course in
                            Button {
                                path.append(Route.courseDetail(course: course))
                            } label: {
                                HStack {
                                    Text("\(course.period)")
                                        .foregroundStyle(.secondary)
                                    Text(course.title)
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .fontWeight(.thin)
                                }
                                .tint(.primary)
                            }
                        }
                    }
                }
                // MARK: - field trips
                Section {
                    emptyRowView(type: "field trip")
                }
            }
            // MARK: - modifiers
            .task(id: calendarMaker.year) {
                await calendarMaker.cacheHolidays()
            }
            .navigationTitle("Teacher Notebook")
            .navigationDestination(for: Route.self) { route in
                switch route {
                    case .dateCell(let day):
                        CellDetailView(path: $path, day: day, holidays: calendarMaker.holidayCache[calendarMaker.year] ?? [])
                            .navigationTransition(.zoom(sourceID: day.id, in: zoomCell))
                    case .courseDetail(let course):
                        CourseDetailView(path: $path, course: course)
                    case .studentDetail(let student, let course):
                        StudentDetailView(path: $path, student: student, course: course)
                    case .assignmentDetail(let assignment):
                        AssignmentDetailView(path: $path, assignment: assignment)
                    case .noteDetail(let course, let note):
                        NoteView(path: $path, course: course, note: note)
                    case .studentList(let course):
                        StudentListView(path: $path, course: course)
                    case .assignmentList(let course):
                        AssignmentListView(path: $path, course: course)
                    case .noteList(let course):
                        NoteListView(path: $path, course: course)
                    case .dataView(let course):
                        DataView(path: $path, course: course)
                    case .lessonList(let course):
                        LessonListView(path: $path, course: course)
                    case .studentGrade(let student, let course):
                        StudentGradesView(path: $path, student: student, course: course)
                    case .lessonDetail(let course, let lesson):
                        LessonDetailView(path: $path, course: course, lesson: lesson)
                    case .documentation(let course):
                        DocumentationView(course: course, path: $path)
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Button("New Class") { activeSheet = .newCourse }
                        Button("New Event") { activeSheet = .newEvent }
                        Button("New Field Trip") { activeSheet = .newFieldTrip }
                        Divider()
                        Button("Calendar Settings") { activeSheet = .calendarSettings }
                        Button("Teacher Settings") { activeSheet = .teacherSettings}
                    } label: {
                        Image(systemName: "ellipsis.circle")
                    }
                }
            }
            .sheet(item: $activeSheet) { sheet in
                switch sheet {
                    case .teacherSettings: TeacherSettingsView()
                    case .calendarSettings: CalendarSettingsView()
                    case .newEvent: NewEventView()
                    case .newCourse: NewCourseView()
                    case .newFieldTrip: NewFieldTripView()
                }
            }
            .sheet(isPresented: $showOnboarding) {
                OnboardingView()
            }
            .onAppear {
                if !onboarded {
                    showOnboarding = true
                    onboarded = true
                }
            }
        }
        .tint(.primary)
    }
    @ViewBuilder
    func emptyRowView(type: String) -> some View {
        HStack {
            Spacer()
            Text("Tap the menu to add \(type)(s)")
            Image(systemName: "ellipsis.circle")
            Spacer()
        }
        .font(.caption)
        .foregroundStyle(.secondary)
        .listRowBackground(Color.clear)
    }
}

//#Preview {
//    ContentView()
//}


// MAKE A THING THAT PACKAGES STUDENT PROGRESS IN A NICE EMAIL AND MAKE IT SHAREABLE WITH PARENTS

//@Observable
//final class CSVHandler {
//    @State var students = [Student]()
//}
