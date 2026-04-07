//
//  Navigator.swift
//  TeacherNotebook2
//
//  Created by Travis Domenic Ratliff on 3/21/26.
//
import Observation
import SwiftUI

@Observable
class Navigator {
    var path = NavigationPath()
    func next<V: Hashable>(_ value: V) {
        path.append(value)
    }
    func previous() {
        path.removeLast()
    }
    func goHome() {
        path.removeLast(path.count)
    }
}
