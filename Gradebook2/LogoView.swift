//
//  LogoView.swift
//  Gradebook2
//
//  Created by Travis Domenic Ratliff on 1/22/25.
//

import SwiftUI

struct LogoView: View {
    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(.red.opacity(0.375))
                .frame(width: 200, height: 40)
            RoundedRectangle(cornerRadius: 10)
                .fill(.purple.opacity(0.375))
                .frame(width: 200, height: 40)
                .overlay {
                    Text("Teacher         ")
                        .font(Font.custom("Rubik-Medium", size: 30))
                }
            RoundedRectangle(cornerRadius: 10)
                .fill(.orange.opacity(0.375))
                .frame(width: 200, height: 40)
                .overlay {
                    Text("Notebook      ")
                        .font(Font.custom("Rubik-Medium", size: 30))
                }
            RoundedRectangle(cornerRadius: 10)
                .fill(.blue.opacity(0.375))
                .frame(width: 200, height: 40)
        }
    }
}

#Preview {
    LogoView()
}
