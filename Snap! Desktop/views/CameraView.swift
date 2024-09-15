//
//  CameraView.swift
//  Snap!
//
//  Created by vin chen on 21/05/24.
//

import SwiftUI
import CoreML
import Foundation

struct CameraView: View {
    @Binding var imageData: Data?
    @Binding var showCamera: Bool
    
    @State internal var VM = CameraViewModel()
    @State internal var TVM = TimerViewModel() 
    
    @Binding var armflexProb: Double
    @Binding var shouldNavigate: Bool
    
    var ExerciseModel = ExcerciseClassifier()
    
    struct PieSegment: Shape {
        var start: Angle
        var end: Angle

        func path(in rect: CGRect) -> Path {
            var path = Path()
            let center = CGPoint(x: rect.midX, y: rect.midY)
            let radius = min(rect.width, rect.height) / 2

            path.addArc(center: center, radius: radius, startAngle: start, endAngle: end, clockwise: false)
            
            return path
        }
    }

    var photoCaptureTimer: some View {

        ZStack {
            Circle()
                .fill(Color.white)
                .frame(width: 65, height: 65)
                .padding(5)
            Circle()
                .stroke(Color.white, lineWidth: 3)
                .frame(width: 75, height: 75)
                .padding(5)
            PieSegment(start: .degrees(Double(TVM.countDown) * 45), end: .degrees(360))
                .stroke(Color.red, lineWidth: 3)
                .frame(width: 75, height: 75)
                .padding(5)
                .rotationEffect(.degrees(270))
            Text("\(8 - TVM.integralCount)")
                .foregroundColor(Color.black)
                .font(.largeTitle)
                
        }
    }
    
    var body: some View {
        VStack{
            ZStack {
                cameraPreview
                Image("cameraLayer")
                    .resizable()
                    .scaledToFill()
                VStack{
                    Spacer()
                    HStack {
                        photoCaptureTimer
                    }
                        .frame(height: 120)
                }
            }
        }
        .onChange(of: TVM.countDown) { oldValue, newValue in
            
            if newValue >= 8 {
                VM.takePhoto()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    imageData = VM.photoData
                    VM.runHumanBodyPoseRequestOnImage()
                    
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    showCamera = false
                    if VM.hasPose{
                        print("has pose")
                        classifyImage()
                    }else{
                        print("no pose")
                        armflexProb = 0.0
                        shouldNavigate = true
                    }
                }
            }
        }
        
    }
    
    func classifyImage(){
        if let mlMultiArray = VM.convertPoseObservationToMLArray() {
            let modelInput = ExcerciseClassifierInput(poses: mlMultiArray)
            do {
                let modelOutput = try ExerciseModel.prediction(input: modelInput)
                if let armflexProbability = modelOutput.labelProbabilities["armflex"] {
                    armflexProb = armflexProbability
                    shouldNavigate = true
                        print("Probability of armflex: \(armflexProbability)")
                } else {
                    print("Class label 'armflex' not found in labelProbabilities")
                }
                
            } catch {
                // Handle the error here
                print("Error occurred during prediction: \(error)")
            }
        }
    }
    
    private var cameraPreview: some View {
        CameraPreview(cameraVM: $VM)
            .ignoresSafeArea()
            .onAppear(){
                VM.requestAccessAndSetup()
            }
    }
}



#Preview {
    CameraView(imageData: .constant(nil), showCamera: .constant(true), armflexProb: .constant(0.0), shouldNavigate: .constant(false))
}

