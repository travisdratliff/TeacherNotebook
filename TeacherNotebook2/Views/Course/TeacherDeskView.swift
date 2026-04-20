//
//  TeacherDeskView.swift
//  TeacherNotebook2
//
//  Created by Travis Domenic Ratliff on 3/21/26.
//

import SwiftUI

struct TeacherDeskView: View {
    @Environment(\.colorScheme) var scheme
    @Binding var deskX: Double
    @Binding var deskY: Double
    var containerHeight: CGFloat
    var containerWidth: CGFloat
    var onMoved: () -> Void = {}
    @State var dragOffset: CGSize = .zero
    var body: some View {
        ZStack {
            Text("Teacher")
                .padding(.all, 8)
                .backgroundModifier(scheme: scheme, amount: 5)
        }
        .offset(x: deskX + dragOffset.width, y: deskY + dragOffset.height)
        .gesture(
            DragGesture()
                .onChanged { value in
                    let maxX = containerWidth / 2 - 44
                    let maxY = containerHeight / 2 - 24
                    dragOffset.width = max(-maxX - deskX, min(maxX - deskX, value.translation.width))
                    dragOffset.height = max(-maxY - deskY, min(maxY - deskY, value.translation.height))
                }
                .onEnded { value in
                    deskX += dragOffset.width
                    deskY += dragOffset.height
                    dragOffset = .zero
                    onMoved()
                }
        )
    }
}

//#Preview {
//    TeacherDeskView()
//}
