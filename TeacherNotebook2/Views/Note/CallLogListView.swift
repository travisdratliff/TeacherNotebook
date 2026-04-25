//
//  CallLogListView.swift
//  TeacherNotebook2
//
//  Created by Travis Domenic Ratliff on 4/25/26.
//

import SwiftUI

struct CallLogListView: View {
    @Binding var path: NavigationPath
    @Bindable var course: Course
    var body: some View {
        List {
            
        }
        .navigationTitle("Call Logs")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
    }
}

//#Preview {
//    CallLogListView()
//}
