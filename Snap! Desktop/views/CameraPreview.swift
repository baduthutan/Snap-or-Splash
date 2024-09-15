//
//  CameraPreview.swift
//  Snap!
//
//  Created by vin chen on 21/05/24.
//

import SwiftUI
import AVFoundation

struct CameraPreview: UIViewRepresentable {
    @Binding var cameraVM: CameraViewModel
    let frame: CGRect
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: frame)
        cameraVM.preview = AVCaptureVideoPreviewLayer(session: cameraVM.session)
        cameraVM.preview.frame = frame
        cameraVM.preview.videoGravity = .resizeAspectFill
        view.layer.addSublayer(cameraVM.preview)
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        cameraVM.preview.frame = frame
        cameraVM.preview.connection?.videoRotationAngle = UIDevice.current.orientation.videoRotationAngle
    }
}

