//
//  ContentView.swift
//  Gradebook2
//
//  Created by Travis Domenic Ratliff on 1/18/25.
//

import SwiftUI
import SwiftData
import SwiftfulRouting

struct ContentView: View {
    var body: some View {
        RouterView { _ in
            ClassListView()
        }
        .tint(.primary)
    }
}

//#Preview {
//    ContentView()
//}
