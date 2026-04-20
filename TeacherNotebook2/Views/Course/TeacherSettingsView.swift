//
//  TeacherSettingsView.swift
//  TeacherNotebook2
//
//  Created by Travis Domenic Ratliff on 3/21/26.
//

import SwiftUI
import SwiftData

struct TeacherSettingsView: View {
    @Environment(\.self) var environment
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var scheme
    @Query(sort: \GradingPeriod.startDate) var gradingPeriods: [GradingPeriod]
    @Query(sort: \GradingWeight.percentage) var gradingWeights: [GradingWeight]
    @State var title = ""
    @State var percentage: Double? = nil
    @State var selectedColor = Color.primary
    @State var resolved: Color.Resolved?
    var body: some View {
        NavigationStack {
            List {
                Section {
                    TextField("Grade Weight Title", text: $title)
                    ColorPicker("Choose Color", selection: $selectedColor)
                    TextField("Weight Percentage (0.25 for 25%, etc)", value: $percentage, format: .number)
                        .keyboardType(.decimalPad)
                } header: {
                    Text("assignment weights")
                }
                Section {
                    HStack {
                        Spacer()
                        Button {
                            appendWeight()
                        } label: {
                            Text("Add Weight")
                                .saveButtonModifier(scheme: scheme)
                        }
                        .buttonStyle(.borderless)
                    }
                    .listRowBackground(Color.clear)
                }
                Section {
                    
                } header: {
                    Text("grading cycles")
                }
                Section {
                    ForEach(gradingWeights) { weight in
                        HStack {
                            Text(weight.title)
                            Spacer()
                            Text("\(weight.percentage.formatted(.percent))")
                        }
                        .listRowBackground(Color(red: Double(weight.red), green: Double(weight.green), blue: Double(weight.blue)))
                    }
                } header: {
                    Text("current assignment weights")
                }
                Section {
                    ForEach(gradingPeriods) { period in
                        HStack {
                            Text(period.title)
                            Spacer()
                            VStack(alignment: .trailing) {
                                Text("Starts: \(period.startDate, style: .date)")
                                Text("Ends: \(period.endDate, style: .date)")
                            }
                        }
                    }
                } header: {
                    Text("current grading periods")
                }
                Section {
                    HStack {
                        Spacer()
                        Button {
                            
                            dismiss()
                        } label: {
                            Text("Save")
                                .saveButtonModifier(scheme: scheme)
                        }
                        .buttonStyle(.borderless)
                    }
                    .listRowBackground(Color.clear)
                }
            }
            .navigationTitle("Settings")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "minus")
                    }
                }
            }
        }
    }
    func appendWeight() {
        resolved = selectedColor.resolve(in: environment)
        if let color = resolved {
            let gradingWeight = GradingWeight(title: title, percentage: percentage ?? 0.0, red: Double(color.red), green: Double(color.green), blue: Double(color.blue))
            modelContext.insert(gradingWeight)
        }
        title = ""
        percentage = nil
        selectedColor = .primary
    }
    func appendGradingPeriod() {
        
    }
    func onboard() {
        for gradingPeriod in gradingPeriods {
            modelContext.insert(gradingPeriod)
        }
        for weight in gradingWeights {
            modelContext.insert(weight)
        }
    }
}

//#Preview {
//    TeacherSettingsView()
//}
