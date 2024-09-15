//
//  CameraView.swift
//  Snap!
//
//  Created by vin chen on 21/05/24.
//

import SwiftUI

struct CameraView: View {
    @Binding var imageData: Data?
    @Binding var showCamera: Bool
    
    @State internal var VM = CameraViewModel()
    
    let controlButtonWidth: CGFloat = 120


    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            
            VStack {
                ZStack{
                    cameraPreview
                    Image("Wall_1")
                        .resizable()
                        .scaledToFill()
                        .edgesIgnoringSafeArea(.all)
                }
                horizontalControlBar
                    .frame(height: 120)
            }
            
           
        }
    }

    private var cameraPreview: some View {
        GeometryReader { geo in
            CameraPreview(cameraVM: $VM, frame: geo.frame(in: .global))
                .ignoresSafeArea()
                .onAppear(){
                    VM.requestAccessAndSetup()
                }
        }
    }

    

}

#Preview {
    CameraView(imageData: .constant(nil), showCamera: .constant(true))
}
