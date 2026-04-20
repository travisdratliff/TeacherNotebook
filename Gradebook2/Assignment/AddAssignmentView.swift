//
//  AddAssignmentView.swift
//  Gradebook2
//
//  Created by Travis Domenic Ratliff on 1/19/25.
//

import SwiftUI
import SwiftData
import SwiftfulRouting

struct AddAssignmentView: View {
    
    @Environment(\.router) var router
    @Environment(\.modelContext) var modelContext
    
    @Query var classes: [Class]
    
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
                .listRowBackground(pickedColor())
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
                    .disabled(clsrm.period == c.period)
                }
            } header: {
                Text("Classes")
            }
        }
        .listStyle(.plain)
        .navigationTitle("New Assignment")
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button("", systemImage: "minus") {
                    router.dismissScreen()
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                
                Button("", systemImage: "plus") {
                    addClass()
                }
                .disabled(title.trim().isEmpty)
            }
        }
        .onAppear {
            c.picked = true
            classes.forEach { clsrm in
                if clsrm.period != c.period {
                    clsrm.picked = false
                }
            }
        }
    }
    func addClass() {
        for clsrm in classes {
            if clsrm.assignmentOriginals.contains(where: { $0.title == title }) {
                router.showBasicAlert(text: "An assignment with this title already exists for this class or other classes")
                title = ""
                break
            } else {
                let ao = AssignmentOriginal(title: title, weight: weight, dueDate: dueDate)
                if clsrm.picked {
                    clsrm.assignmentOriginals.append(ao)
                    clsrm.students.forEach { s in
                        let a = Assignment(title: ao.title, weight: ao.weight, grade: "", fullName: s.fullName, dueDate: ao.dueDate)
                        a.firstName = s.firstName
                        a.lastName = s.lastName
                        s.assignments.append(a)
                    }
                    clsrm.picked = false
                    router.dismissScreen()
                }
            }
        }
    }
    func pickedColor() -> Color {
        switch weight {
        case .Daily:
            return Color.blue.opacity(0.375)
        case .Quiz:
            return Color.orange.opacity(0.375)
        case .Project:
            return Color.purple.opacity(0.375)
        case .Test:
            return Color.red.opacity(0.375)
        }
    }
}

//#Preview {
//    AddAssignmentView()
//}
