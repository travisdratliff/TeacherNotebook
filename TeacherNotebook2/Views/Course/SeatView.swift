//
//  SeatView.swift
//  TeacherNotebook2
//
//  Created by Travis Domenic Ratliff on 3/21/26.
//

import SwiftUI

struct SeatView: View {
    @Binding var seat: Seat
    var containerHeight: CGFloat
    var containerWidth: CGFloat
    var onMoved: () -> Void = {}
    @State var dragOffset: CGSize = .zero
    var body: some View {
        VStack {
            Image(systemName: "person.crop.square")
                .font(.largeTitle)
            if let firstLetter = seat.lastName.first {
                Text("\(seat.firstName) \(String(firstLetter)).")
                    .font(.caption2)
            }
        }
        .offset(x: seat.x + dragOffset.width, y: seat.y + dragOffset.height)
        .gesture(
            DragGesture()
                .onChanged { value in
                    let maxX = containerWidth / 2 - 21
                    let maxY = containerHeight / 2 - 28
                    dragOffset.width = max(-maxX - seat.x, min(maxX - seat.x, value.translation.width))
                    dragOffset.height = max(-maxY - seat.y, min(maxY - seat.y, value.translation.height))
                }
                .onEnded { value in
                    seat.x += dragOffset.width
                    seat.y += dragOffset.height
                    dragOffset = .zero
                    onMoved()
                }
        )
    }
}

//#Preview {
//    SeatView()
//}
