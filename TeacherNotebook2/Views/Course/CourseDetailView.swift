//
//  CourseDetailView.swift
//  TeacherNotebook2
//
//  Created by Travis Domenic Ratliff on 3/21/26.
//

import SwiftUI
import SwiftData

struct CourseDetailView: View {
    //
    @Environment(\.modelContext) var modelContext
    //
    @Query var students: [Student]
    //
    @Binding var path: NavigationPath
    @Bindable var course: Course
    //
    @State var showExportSeatingChartAlert = false
    @State var seatingChartURL: URL? = nil
    @State var showSettings = false
    //
    var body: some View {
        List {
            Section {
                Button {
                    path.append(Route.studentList(course: course))
                } label: {
                    HStack {
                        Text("Students")
                        Spacer()
                        Image(systemName: "chevron.right")
                            .fontWeight(.thin)
                    }
                }
                Button {
                    path.append(Route.assignmentList(course: course))
                } label: {
                    HStack {
                        Text("Assignments")
                        Spacer()
                        Image(systemName: "chevron.right")
                            .fontWeight(.thin)
                    }
                }
                Button {
                    path.append(Route.lessonList(course: course))
                } label: {
                    HStack {
                        Text("Lesson Plans")
                        Spacer()
                        Image(systemName: "chevron.right")
                            .fontWeight(.thin)
                    }
                }
                Button {
                    path.append(Route.noteList(course: course))
                } label: {
                    HStack {
                        Text("Notes")
                        Spacer()
                        Image(systemName: "chevron.right")
                            .fontWeight(.thin)
                    }
                }
                Button {
                    
                } label: {
                    HStack {
                        Text("Call Logs")
                        Spacer()
                        Image(systemName: "chevron.right")
                            .fontWeight(.thin)
                    }
                }
                Button {
                    path.append(Route.dataView(course: course))
                } label: {
                    HStack {
                        Text("Data")
                        Spacer()
                        Image(systemName: "chevron.right")
                            .fontWeight(.thin)
                    }
                }
            }
            Section {
                GroupBox("Seating Chart") {
                    SeatingChartView(seats: $course.seats, deskX: $course.desk.x, deskY: $course.desk.y, onMoved: {
                        seatingChartURL = exportToPDF(renderImage())
                    })
                }
                .listRowBackground(Color.clear)
                .listRowInsets(EdgeInsets())
                .backgroundStyle(Color(uiColor: .secondarySystemGroupedBackground))
            } // maybe add a header again idk
        }
        .navigationTitle(course.title)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    path.removeLast()
                } label: {
                    Image(systemName: "arrow.turn.up.left")
                }
                .tint(.primary)
            }
            ToolbarItem(placement: .principal) {
                Text("Period \(course.period)")
                    .foregroundStyle(.secondary)
            }
            ToolbarItem(placement: .topBarTrailing) {
                Menu {
                    ShareLink(item: seatingChartURL ?? URL.documentsDirectory) {
                        HStack {
                            Text("Seating Chart")
                            Image(systemName: "square.and.arrow.up")
                        }
                    }
                    Divider()
                    Button("\(course.title) Settings") { showSettings.toggle() }
                    Divider()
                    Button("Delete Course", role: .destructive) {
                        modelContext.delete(course)
                        path.removeLast()
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                }
                .tint(.primary)
            }
        }
        .onAppear {
            seatingChartURL = exportToPDF(renderImage())
        }
        .sheet(isPresented: $showSettings) {
            CourseSettingsView(course: course)
        }
    }
    func exportToPDF<V: View>(_ view: V) -> URL? {
        let renderer = ImageRenderer(content: view)
        renderer.scale = 1.0
        let url = URL.documentsDirectory.appending(path: "SeatingChart\(course.id).pdf")
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
        SeatingChartView(
            seats: $course.seats,
            deskX: $course.desk.x,
            deskY: $course.desk.y
        )
        .frame(width: 612, height: 612)
    }
}

//#Preview {
//    CourseDetailView()
//}
