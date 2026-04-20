//
//  SeatingChartView.swift
//  TeacherNotebook2
//
//  Created by Travis Domenic Ratliff on 3/21/26.
//

import SwiftUI

struct SeatingChartView: View {
    @Binding var seats: [Seat]
    @Binding var deskX: Double
    @Binding var deskY: Double
    var onMoved: () -> Void = {}
    var body: some View {
        GeometryReader { geometry in
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.clear)
                .frame(width: geometry.size.width)
                .overlay(
                    ZStack {
                        ForEach($seats, id: \.id) { $seat in
                            SeatView(seat: $seat, containerHeight: geometry.size.height, containerWidth: geometry.size.width, onMoved: onMoved)
                        }
                        TeacherDeskView(deskX: $deskX, deskY: $deskY, containerHeight: geometry.size.height, containerWidth: geometry.size.width, onMoved: onMoved)
                    }
                )
        }
        .aspectRatio(1/1, contentMode: .fill)
    }
}

//#Preview {
//    SeatingChartView()
//}
