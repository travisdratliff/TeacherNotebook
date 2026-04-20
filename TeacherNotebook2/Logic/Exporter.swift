//
//  Exporter.swift
//  TeacherNotebook2
//
//  Created by Travis Domenic Ratliff on 3/21/26.
//
import SwiftUI

@MainActor
class Exporter {
    static func exportToPDF<V: View>(_ view: V) -> URL? {
        let renderer = ImageRenderer(content: view)
        let url = URL.documentsDirectory.appending(path: "exported_image.pdf")
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
    static func exportStudents(course: Course) -> URL {
        var fileURL: URL!
        let heading = "Student ID, First Name, Last Name\n"
        let rows = course.students.sorted {
            $0.lastName < $1.lastName
        }.map {
            "\($0.id),\($0.firstName),\($0.lastName)"
        }
        let stringData = heading + rows.joined(separator: "\n")
        do {
            let path = try FileManager.default.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: false)
            fileURL = path.appending(path: "\(course.title)-students.csv")
            try stringData.write(to: fileURL, atomically: true, encoding: .utf8)
            print(fileURL!)
        } catch {
            print("error generating csv file")
        }
        return fileURL
    }
}
