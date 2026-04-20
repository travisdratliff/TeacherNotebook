//
//  SplashScreen.swift
//  TeacherNotebook2
//
//  Created by Travis Domenic Ratliff on 4/13/26.
//

import SwiftUI
 
struct SplashScreen: View {
    var body: some View {
        VStack(alignment: .center) {
            Text("{ spriteHouse }")
                .font(.largeTitle)
                .bold()
            Text("STUDIOS")
                .font(.caption2)
                .fontWeight(.light)
                .tracking(7)
        }
    }
}

//#Preview {
//    SplashScreen()
//}
