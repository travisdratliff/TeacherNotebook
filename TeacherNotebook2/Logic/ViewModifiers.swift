//
//  ViewModifiers.swift
//  TeacherNotebook2
//
//  Created by Travis Domenic Ratliff on 3/21/26.
//
import SwiftUI

struct SaveButtonModifier: ViewModifier {
    var scheme: ColorScheme
    func body(content: Content) -> some View {
        content
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [Color(red: scheme == .dark ? 0.71 : 1, green: scheme == .dark ? 0.55 : 0.8, blue: scheme == .dark ? 0.82 : 0.68), Color(red: scheme == .dark ? 0.58 : 1, green: scheme == .dark ? 0.39 : 0.6, blue: scheme == .dark ? 0.73 : 0.59)]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
            )
    }
}

struct PlusButtonModifier: ViewModifier {
    var scheme: ColorScheme
    func body(content: Content) -> some View {
        content
            .foregroundStyle(
                .linearGradient(
                    colors: [Color(red: scheme == .dark ? 0.71 : 1, green: scheme == .dark ? 0.55 : 0.8, blue: scheme == .dark ? 0.82 : 0.68), Color(red: scheme == .dark ? 0.58 : 1, green: scheme == .dark ? 0.39 : 0.6, blue: scheme == .dark ? 0.73 : 0.59)],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
    }
}

struct BackgroundModifier: ViewModifier {
    var scheme: ColorScheme
    var amount: CGFloat
    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: amount)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [Color(red: scheme == .dark ? 0.71 : 1, green: scheme == .dark ? 0.55 : 0.8, blue: scheme == .dark ? 0.82 : 0.68), Color(red: scheme == .dark ? 0.58 : 1, green: scheme == .dark ? 0.39 : 0.6, blue: scheme == .dark ? 0.73 : 0.59)]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
            )
    }
}

extension View {
    func saveButtonModifier(scheme: ColorScheme) -> some View {
        self.modifier(SaveButtonModifier(scheme: scheme))
    }
    func backgroundModifier(scheme: ColorScheme, amount: CGFloat) -> some View {
        self.modifier(BackgroundModifier(scheme: scheme, amount: amount))
    }
    func plusButtonModifer(scheme: ColorScheme) -> some View {
        self.modifier(PlusButtonModifier(scheme: scheme))
    }
}
<<<<<<< HEAD
=======

extension Date {
    func yyyyDDmm() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: self)
    }
}
>>>>>>> bff29d8bf5549a352338a6adbb20613857e27695
