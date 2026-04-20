//
//  EditAssignmentView.swift
//  Gradebook2
//
//  Created by Travis Domenic Ratliff on 1/25/25.
//

import SwiftUI
import SwiftData
import SwiftfulRouting

struct EditAssignmentView: View {
    
    @Environment(\.router) var router
    @Environment(\.modelContext) var modelContext
    
    @Query var classes: [Class]
    
    var ao: AssignmentOriginal
    var c: Class
    
    @State var title = ""
    @State var weight = Weight.Daily
    @State var dueDate = Date.now
    
    var body: some View {
        List {
            Section {
                TextField("Title", text: $title)
                Picker("Weight", selection: $weight) {
                    ForEach(Weight.allCases, id: \.self) {
                        Text($0.rawValue)
                    }
                }
                .pickerStyle(.segmented)
                DatePicker("Due Date", selection: $dueDate, displayedComponents: .date)
                    .datePickerStyle(.compact)
            } header: {
                Text("Details")
            }
            Section {
                ForEach(classes.sorted { $0.period < $1.period }) { clsrm in
                    Button {
                        clsrm.picked.toggle()
                    } label: {
                        HStack {
                            Text(clsrm.period)
                                .foregroundStyle(.secondary)
                            Text(clsrm.title)
                            Spacer()
                            Image(systemName: clsrm.picked ? "circle.fill" : "circle")
                        }
                    }
                    .disabled(clsrm.assignmentOriginals.contains(where: { $0.title == ao.title }))
                }
            } header: {
                Text("Classes")
            }
        }
        .listStyle(.plain)
        .navigationTitle("Edit Assignment")
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button("", systemImage: "minus") {
                    router.dismissScreen()
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button("", systemImage: "checkmark") {
                    let oldTitle = ao.title
                    let newTitle = title
                    classes.forEach { clsrm in
                        guard clsrm.assignmentOriginals.contains(where: { $0.title == newTitle && $0.title != oldTitle }) else {
                            clsrm.assignmentOriginals.forEach { ao in
                                if ao.title == oldTitle {
                                    ao.title = title
                                    ao.weight = weight
                                    ao.dueDate = dueDate
                                    clsrm.students.forEach { s in
                                        s.assignments.forEach { a in
                                            if a.title == oldTitle {
                                                a.title = title
                                                a.weight = weight
                                                a.dueDate = dueDate
                                            }
                                        }
                                    }
                                }
                            }
                            if clsrm.picked && !clsrm.assignmentOriginals.contains(where: { $0.title == ao.title }) {
                                let newAo = AssignmentOriginal(title: title, weight: weight, dueDate: dueDate)
                                clsrm.assignmentOriginals.append(newAo)
                                clsrm.students.forEach { s in
                                    let a = Assignment(title: ao.title, weight: ao.weight, grade: "", fullName: s.fullName, dueDate: ao.dueDate)
                                    a.firstName = s.firstName
                                    a.lastName = s.lastName
                                    s.assignments.append(a)
                                }
                            }
                            do {
                                try modelContext.save()
                            } catch {
                                print(error.localizedDescription)
                            }
                            router.dismissScreen()
                            return
                        }
                        router.showBasicAlert(text: "There is already another assignment with this title in this class or other classes") {
                            title = oldTitle
                        }
                    }
                }
                .disabled(title.trim().isEmpty)
            }
        }
        .onAppear {
            title = ao.title
            weight = ao.weight
            dueDate = ao.dueDate
            classes.forEach { clsrm in
                if clsrm.assignmentOriginals.contains(where: { $0.title == ao.title }) {
                    clsrm.picked = true
                }
            }
        }
        .onDisappear {
            classes.forEach { clsrm in
                clsrm.picked = false
            }
        }
    }
}

//#Preview {
//    EditAssignmentView()
//}
