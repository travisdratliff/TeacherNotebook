//
//  StudentListView.swift
//  TeacherNotebook2
//
//  Created by Travis Domenic Ratliff on 3/21/26.
//

import SwiftUI
import SwiftData
internal import UniformTypeIdentifiers

struct StudentListView: View {
    @Query(sort: \Course.period) var courses: [Course]
    @Binding var path: NavigationPath
    @Bindable var course: Course
    @State var showImportStudentAlert = false
    @State var showDocumentPicker = false
    @State var searchText = ""
    @State var showSearch = false
    @State var showNewStudent = false
    var filteredStudents: [Student] {
        let trimmed = searchText.trimmingCharacters(in: .whitespaces)
        return course.students
            .filter { trimmed.isEmpty || $0.fullName.localizedCaseInsensitiveContains(trimmed) }
            .sorted { $0.lastName < $1.lastName }
    }
    var body: some View {
        List {
            ForEach(filteredStudents, id: \.id) { student in
                Button {
                    path.append(Route.studentDetail(student: student, course: course))
                } label: {
                    HStack {
                        Text("\(student.lastName), \(student.firstName)")
                        Spacer()
                        Image(systemName: "chevron.right")
                    }
                }
                .tint(.primary)
            }
        }
        .navigationTitle("Students")
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItemGroup(placement: .topBarLeading) {
                Button {
                    path.removeLast()
                } label: {
                    Image(systemName: "arrow.turn.up.left")
                }
                Menu {
                    Button("Home") {
                        path.removeLast(path.count)
                    }
                    if courses.count > 1 {
                        Divider()
                        ForEach(courses) { menuCourse in
                            if course.period != menuCourse.period {
                                Button("\(menuCourse.period) - \(menuCourse.title) Students") {
                                    Task {
                                        path.removeLast(path.count)
                                        try? await Task.sleep(for: .seconds(0.15))
                                        path.append(Route.courseDetail(course: menuCourse))
                                        try? await Task.sleep(for: .seconds(0.15))
                                        path.append(Route.studentList(course: menuCourse))
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
            ToolbarItemGroup(placement: .topBarTrailing) {
                Button {
                    showSearch.toggle()
                } label: {
                    Image(systemName: "magnifyingglass")
                }
                Menu {
                    Button("New Student") { showNewStudent.toggle() }
                    Button("Import Students") { showImportStudentAlert.toggle() }
                    ShareLink(item: Exporter.exportStudents(course: course)) {
                        Text("Export Students")
                    }
                    .disabled(course.students.isEmpty)
                } label: {
                    Image(systemName: "ellipsis.circle")
                }
            }
        }
        .searchable(text: $searchText, isPresented: $showSearch, prompt: "Search for Student")
        .sheet(isPresented: $showNewStudent) {
            NewStudentView(course: course)
        }
        .alert("Import Student CSV", isPresented: $showImportStudentAlert) {
            Button("Choose CSV File") {
                showDocumentPicker.toggle()
            }
            Button("Cancel", role: .cancel) { }
                .tint(.blue)
        } message: {
            Text("Make sure your CSV file has 3 columns with these headers: student id, first name, and last name, in that order. Do not put commas between the last name and a generational suffix (like 'Jr' or 'II')")
        }
        .fileImporter(
            isPresented: $showDocumentPicker,
            allowedContentTypes: [.plainText, .commaSeparatedText],
            allowsMultipleSelection: false
        ) { result in
            switch result {
                case .success(let urls):
                    guard let url = urls.first else { return }
                    guard url.startAccessingSecurityScopedResource() else { return }
                    defer { url.stopAccessingSecurityScopedResource() }
                    let parsed = /*Importer.*/importStudents(from: url)
                    /*Importer.*/appendStudents(course: course, parsed: parsed)
                    print("Got file: \(url.lastPathComponent)")
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
            }
        }
    }
    func parseRow(_ row: String) -> [String] {
        var columns: [String] = []
        var current = ""
        var inQuotes = false
        for char in row {
            if char == "\"" {
                inQuotes.toggle()
            } else if char == "," && !inQuotes {
                columns.append(current.trimmed())
                current = ""
            } else {
                current.append(char)
            }
        }
        columns.append(current.trimmed())
        return columns
    }
    func importStudents(from url: URL) -> [Student] {
        var students: [Student] = []
        guard let contents = try? String(contentsOf: url, encoding: .utf8) else {
            print("Couldn't read file")
            return []
        }
        let rows = contents.components(separatedBy: .newlines)
        for row in rows.dropFirst() {
            let columns = parseRow(row)
            guard columns.count >= 3 else { continue }
            students.append(Student(
                id: columns[0],
                firstName: columns[1],
                lastName: columns[2]
            ))
        }
        return students
    }
    func appendStudents(course: Course, parsed: [Student]) {
        for student in parsed {
            guard !course.students.contains(where: { $0.id == student.id }) else { continue }
            course.students.append(student)
            course.seats.append(Seat(id: student.id, firstName: student.firstName, lastName: student.lastName))
            for assignment in course.assignments {
                if let unwrappedWeight = assignment.weight {
                    let grade = Grade(weight: unwrappedWeight, student: student)
                    assignment.grades.append(grade)
                }
            }
        }
    }
}

//#Preview {
//    StudentListView()
//}
