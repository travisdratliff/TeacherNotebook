//
//  CameraPreview.swift
//  RoofShingleIdentifier
//
//  Created by Travis Domenic Ratliff on 4/24/26.
//

import SwiftUI
import AVFoundation

struct CameraPreview: UIViewRepresentable {
    let session: AVCaptureSession
    func makeUIView(context: Context) -> PreviewView {
        let view = PreviewView()
        view.previewLayer.session = session
        view.previewLayer.videoGravity = .resizeAspectFill
        return view
    }
    func updateUIView(_ uiView: PreviewView, context: Context) {}
    class PreviewView: UIView {
        override class var layerClass: AnyClass {
            AVCaptureVideoPreviewLayer.self
        }
        var previewLayer: AVCaptureVideoPreviewLayer {
            layer as! AVCaptureVideoPreviewLayer
        }
    }
}

actor CameraSession {
    let session = AVCaptureSession()
    private var isConfigured = false

    func setup(with device: AVCaptureDevice) {
        guard !isConfigured else { return }
        session.beginConfiguration()
        guard
            let input = try? AVCaptureDeviceInput(device: device),
            session.canAddInput(input)
        else {
            session.commitConfiguration()
            return
        }
        session.addInput(input)
        session.commitConfiguration()
        isConfigured = true
    }

    func start() {
        guard isConfigured, !session.isRunning else { return }
        session.startRunning()
    }

    func stop() {
        guard session.isRunning else { return }
        session.stopRunning()
    }

    func restart() {
        guard isConfigured else { return }
        if session.isRunning { session.stopRunning() }
        session.startRunning()
    }
}

@Observable
class CameraManager {
    var isRunning = false
    var permissionGranted = false
    private let cameraSession = CameraSession()

    var session: AVCaptureSession {
        get async { await cameraSession.session }
    }

    init() {
        Task {
            await requestPermission()
            await setupCamera()
        }
    }

    private func requestPermission() async {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        switch status {
        case .authorized:
            permissionGranted = true
        case .notDetermined:
            permissionGranted = await AVCaptureDevice.requestAccess(for: .video)
        default:
            permissionGranted = false
        }
    }

    private func setupCamera() async {
        guard permissionGranted else { return }
        guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back)
        else { return }
        await cameraSession.setup(with: device)
    }

    func start() {
        Task {
            await cameraSession.start()
            await MainActor.run { isRunning = true }
        }
    }

    func stop() {
        Task {
            await cameraSession.stop()
            await MainActor.run { isRunning = false }
        }
    }

    func restart() {
        Task {
            await cameraSession.restart()
            await MainActor.run { isRunning = true }
        }
    }
}
