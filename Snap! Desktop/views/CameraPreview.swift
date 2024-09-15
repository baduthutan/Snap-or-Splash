//
//  CameraPreview.swift
//  Snap!
//
//  Created by vin chen on 21/05/24.
//

import SwiftUI
import AVFoundation

struct CameraPreview: NSViewRepresentable {
    
    @Binding var cameraVM: CameraViewModel
    
    func makeNSView(context: Context) -> NSView {
        
        let view = NSView(frame: NSRect(x: 0, y: 0, width: 1700, height: 1050))
        cameraVM.preview = AVCaptureVideoPreviewLayer(session: cameraVM.session)
        cameraVM.preview.videoGravity = .resizeAspectFill
        cameraVM.preview.frame = view.bounds // Set preview layer frame
        view.wantsLayer = true
        view.layer!.addSublayer(cameraVM.preview)
        
        return view
    }
    
    func updateNSView(_ nsView: NSView, context: Context) {
  
    }
}



