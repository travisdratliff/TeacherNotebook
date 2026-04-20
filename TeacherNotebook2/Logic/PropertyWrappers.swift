//
//  PropertyWrappers.swift
//  TeacherNotebook2
//
//  Created by Travis Domenic Ratliff on 4/14/26.
//
import SwiftUI

@propertyWrapper
struct Trimmed: DynamicProperty {
    @State var value = ""
    var wrappedValue: String {
        get { value }
        nonmutating set { value = newValue.trimmingCharacters(in: .whitespacesAndNewlines) }
    }
    var projectedValue: Binding<String> {
        Binding(
            get: { self.wrappedValue },
            set: { self.wrappedValue = $0.trimmingCharacters(in: .whitespacesAndNewlines) }
        )
    }
    init(wrappedValue: String) {
        self._value = State(wrappedValue: wrappedValue.trimmingCharacters(in: .whitespacesAndNewlines))
    }
    func reset() {
        $value.wrappedValue = ""
    }
}
