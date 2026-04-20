//
//  OnboardingView.swift
//  TeacherNotebook2
//
//  Created by Travis Domenic Ratliff on 3/21/26.
//

import SwiftUI
import SwiftData

struct OnboardingView: View {
    @Environment(\.self) var environment
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var scheme
    @State var gradingWeightTitle = ""
    @State var percentage = 1
    @State var selectedColor = Color.primary
    @State var resolved: Color.Resolved?
    @State var gradingPeriodTitle = ""
    @State var gradingPeriodStartDate = Date.now
    @State var gradingPeriodEndDate = Date.now
    @State var gradingWeights = [GradingWeight]()
    @State var gradingPeriods = [GradingPeriod]()
    @State var showWeightAlert = false
    @State var showOverlapAlert = false
    var saveIsValid: Bool {
        !gradingPeriods.isEmpty && !gradingWeights.isEmpty
    }
    var body: some View {
        NavigationStack {
            List {
                Section {
                    Text("Welcome to Teacher Notebook! Please fill out the assignment grading weight and grading period text fields below. This information will be used to properly organize your assignments, and also to calculate averages and other data. ")
                    Text("Please understand that this app DOES NOT COLLECT ANY DATA OF ANY KIND. All student, class, and other data lives on your device and your device only. Data may be exported to a CSV or PDF for presentation purposes, but it will not be shared with anyone.")
                }
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
                Section {
                    Picker("Weight Percentage", selection: $percentage) {
                        ForEach(Array(1...100), id: \.self) {
                            Text("\($0)%")
                        }
                    }
                    ColorPicker("Label Color", selection: $selectedColor)
                    HStack {
                        TextField("Grade Weight Title", text: $gradingWeightTitle)
                        Button {
                            appendWeight()
                        } label: {
                            Image(systemName: "plus.circle.fill")
                                .font(.largeTitle)
                                .plusButtonModifer(scheme: scheme)
                        }
                        .buttonStyle(.borderless)
                        .disabled(gradingWeightTitle.trimmed().isEmpty)
                    }
                    .padding(.horizontal)
                    .listRowInsets(EdgeInsets())
                    ForEach(gradingWeights) { weight in
                        HStack {
                            Image(systemName: "rectangle.portrait.fill")
                                .foregroundStyle(Color(red: Double(weight.red), green: Double(weight.green), blue: Double(weight.blue)))
                            Text(weight.title)
                            Spacer()
                            Text("\(weight.percentage.formatted(.percent))")
                        }
                        .swipeActions(edge: .trailing) {
                            Button("Delete", role: .destructive) {
                                if let index = gradingWeights.firstIndex(of: weight) {
                                    gradingWeights.remove(at: index)
                                }
                            }
                            .tint(.red)
                        }
                    }
                } header: {
                    Text("assignment weights")
                }
                Section {
                    DatePicker("Start Date", selection: $gradingPeriodStartDate, displayedComponents: .date)
                    DatePicker("End Date", selection: $gradingPeriodEndDate, displayedComponents: .date)
                    HStack {
                        TextField("Grading Period Title", text: $gradingPeriodTitle)
                        Spacer()
                        Button {
                            appendGradingPeriod()
                        } label: {
                            Image(systemName: "plus.circle.fill")
                                .font(.largeTitle)
                                .plusButtonModifer(scheme: scheme)
                        }
                        .buttonStyle(.borderless)
                        .disabled(gradingPeriodTitle.trimmed().isEmpty)
                    }
                    .padding(.horizontal)
                    .listRowInsets(EdgeInsets())
                    ForEach(gradingPeriods) { period in
                        HStack {
                            Text(period.title)
                            Spacer()
                            VStack(alignment: .trailing) {
                                Text("Starts: \(period.startDate, style: .date)")
                                Text("Ends: \(period.endDate, style: .date)")
                            }
                        }
                        .swipeActions(edge: .trailing) {
                            Button("Delete", role: .destructive) {
                                if let index = gradingPeriods.firstIndex(of: period) {
                                    gradingPeriods.remove(at: index)
                                }
                            }
                            .tint(.red)
                        }
                    }
                } header: {
                    Text("grading periods")
                }
                Section {
                    HStack {
                        Spacer()
                        Button {
                            onboard()
                        } label: {
                            Text("Finish Setup")
                                .saveButtonModifier(scheme: scheme)
                        }
                        .buttonStyle(.borderless)
                        .disabled(!saveIsValid)
                    }
                    .listRowBackground(Color.clear)
                }
            }
            .navigationTitle("Welcome!")
            .interactiveDismissDisabled(true)
        }
        .alert("Check Grading Weights", isPresented: $showWeightAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Your percentages for weights don't add up to 100%. Please add or swipe to delete any weights and try again.")
        }
        .alert("Grading Periods Overlap", isPresented: $showOverlapAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("One or more of your grading periods overlap, please swipe to delete any grading periods and try again.")
        }
    }
    func appendWeight() {
        resolved = selectedColor.resolve(in: environment)
        if let color = resolved {
            let gradingWeight = GradingWeight(title: gradingWeightTitle, percentage: Double(percentage) / 100, red: Double(color.red), green: Double(color.green), blue: Double(color.blue))
            gradingWeights.append(gradingWeight)
        }
        gradingWeightTitle = ""
        percentage = 1
        selectedColor = .primary
    }
    func appendGradingPeriod() {
        let period = GradingPeriod(title: gradingPeriodTitle, startDate: gradingPeriodStartDate, endDate: gradingPeriodEndDate)
        gradingPeriods.append(period)
        gradingPeriodTitle = ""
        gradingPeriodStartDate = Date.now
        gradingPeriodEndDate = Date.now
    }
    func onboard() {
        let totalPercentage = gradingWeights.map({ $0.percentage }).reduce(0.0, +)
        guard abs(totalPercentage - 1.0) < 0.001 else {
            showWeightAlert.toggle()
            return
        }
        guard !gradingPeriods.indices.contains(where: { i in
            gradingPeriods.indices.dropFirst(i + 1).contains(where: { j in
                gradingPeriods[i].dateRange.overlaps(gradingPeriods[j].dateRange)
            })
        }) else {
            showOverlapAlert.toggle()
            return
        }
        for period in gradingPeriods { modelContext.insert(period) }
        for weight in gradingWeights { modelContext.insert(weight) }
        try? modelContext.save()
        dismiss()
    }
}

//#Preview {
//    OnboardingView()
//}
