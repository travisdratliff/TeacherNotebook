//
//  NewTemplateView.swift
//  TeacherNotebook2
//
//  Created by Travis Domenic Ratliff on 4/4/26.
//

import SwiftUI
import SwiftData

struct NewTemplateView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.colorScheme) var scheme
    @Environment(\.dismiss) var dismiss
    @Bindable var course: Course
    @State var textFieldOrder = ""
    @State var templateTitle = ""
    @State var textFieldTitle = ""
    @State var dropDownTitle = ""
    @State var dropDownOption = ""
    @State var dropDownOptions = [String]()
    @State var templateTextFields = [LessonTextField]()
    @State var templateDropDowns = [LessonDropDown]()
    var body: some View {
        NavigationStack {
            List {
                Section {
                    TextField("Template Title", text: $templateTitle)
                } header: {
                    Text("title")
                }
                Section {
        
                        TextField("Text Field Title", text: $textFieldTitle)
                        HStack {
                            TextField("Order In List", text: $textFieldOrder)
                                .keyboardType(.numberPad)
                            Button {
                                let textField = LessonTextField(title: textFieldTitle, order: Int(textFieldOrder) ?? 0, content: "")
                                templateTextFields.append(textField)
                                textFieldOrder = ""
                                textFieldTitle = ""
                            } label: {
                                Image(systemName: "plus.circle.fill")
                                    .font(.largeTitle)
                                    .plusButtonModifer(scheme: scheme)
                            }
                            .buttonStyle(.borderless)
                            .disabled(textFieldTitle.trimmed().isEmpty)
                        }
               
                    .padding(.horizontal)
                    .listRowInsets(EdgeInsets())
                } header: {
                    Text("text fields")
                }
                Section {
                    TextField("Drop Down Title", text: $dropDownTitle)
                    HStack {
                        TextField("Enter Value", text: $dropDownOption)
                        Button {
                            dropDownOptions.append(dropDownOption)
                            dropDownOption = ""
                        } label: {
                            Image(systemName: "plus.circle.fill")
                                .font(.largeTitle)
                                .plusButtonModifer(scheme: scheme)
                        }
                        .buttonStyle(.borderless)
                        .disabled(dropDownOption.trimmed().isEmpty)
                    }
                    .padding(.horizontal)
                    .listRowInsets(EdgeInsets())
                    ForEach(dropDownOptions, id: \.self) { option in
                        Text(option)
                            .swipeActions(edge: .trailing) {
                                Button("Delete", role: .cancel) {
                                    if let index = dropDownOptions.firstIndex(of: option) {
                                        dropDownOptions.remove(at: index)
                                    }
                                }
                                .tint(.red)
                            }
                    }
                    HStack {
                        Spacer()
                        Button {
                            let dropDown = LessonDropDown(title: dropDownTitle, choices: dropDownOptions)
                            templateDropDowns.append(dropDown)
                            dropDownTitle = ""
                            dropDownOption = ""
                            dropDownOptions.removeAll()
                        } label: {
                            Image(systemName: "plus.circle.fill")
                                .font(.largeTitle)
                                .plusButtonModifer(scheme: scheme)
                        }
                        .buttonStyle(.borderless)
                    }
                }
                Section {
                    ForEach(templateTextFields, id: \.self) { content in
                        Text(content.title)
                            .swipeActions(edge: .trailing) {
                                Button("Delete", role: .cancel) {
                                    if let index = templateTextFields.firstIndex(of: content) {
                                        templateTextFields.remove(at: index)
                                    }
                                }
                                .tint(.red)
                            }
                    }
                } header: {
                    Text("created textfields")
                }
                Section {
                    ForEach($templateDropDowns, id: \.self) { $dropDown in
                        Picker(dropDown.title, selection: $dropDown.currentChoice) {
                            ForEach(dropDown.choices, id: \.self) { choice in
                                Text(choice).tag(choice)
                            }
                        }
                        .swipeActions(edge: .trailing) {
                            Button("Delete", role: .cancel) {
                                if let index = templateDropDowns.firstIndex(of: dropDown) {
                                    templateDropDowns.remove(at: index)
                                }
                            }
                            .tint(.red)
                        }
                    }
                } header: {
                    Text("created dropdowns")
                }
                Section {
                    HStack {
                        Spacer()
                        Button("Save") {
                            let template = LessonTemplate()
                            template.title = templateTitle
                            template.textFields.append(contentsOf: templateTextFields)
                            template.dropDowns.append(contentsOf: templateDropDowns)
                            course.templates.append(template)
                            dismiss()
                        }
                        .saveButtonModifier(scheme: scheme)
                    }
                }
            }
            .navigationTitle("New Template")
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
}

//#Preview {
//    NewTemplateView()
//}
