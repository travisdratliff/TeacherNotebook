//
//  CameraView.swift
//  TeacherNotebook2
//
//  Created by Travis Domenic Ratliff on 4/25/26.
//

import SwiftUI
import AVFoundation

struct CameraView: View {
    @State var camera = CameraManager()
    @State var captureSession: AVCaptureSession?
    var body: some View {
        VStack {
            ZStack {
                if camera.permissionGranted, let captureSession {
                    CameraPreview(session: captureSession)
                        .ignoresSafeArea()
                } else {
                    ContentUnavailableView(
                        "Camera Access Required",
                        systemImage: "camera.fill",
                        description: Text("Please allow camera access in Settings.")
                    )
                }
            }
            .onAppear { camera.restart() }
            .onDisappear { camera.stop() }
        }
        .task {
            captureSession = await camera.session
        }
    }
}

#Preview {
    CameraView()
}
