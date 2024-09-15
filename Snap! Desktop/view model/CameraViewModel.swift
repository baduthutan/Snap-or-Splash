//
//  CameraViewModel.swift
//  Snap! Desktop
//
//  Created by vin chen on 21/05/24.
//

import Foundation
import AVFoundation
import SwiftUI
import Vision
import CoreML

@Observable
class CameraViewModel: NSObject {
    
    enum PhotoCaptureState {
        case notStarted
        case processing
        case finished(Data)
    }
    
    var humanObservation: VNHumanBodyPoseObservation? = nil
    
    var session = AVCaptureSession()
    var preview = AVCaptureVideoPreviewLayer()
    var output = AVCapturePhotoOutput()
    
    private(set) var photoCaptureState: PhotoCaptureState = .notStarted
    
    var photoData: Data? {
        if case .finished(let data) = photoCaptureState {
            return data
        }
        return nil
    }

    var hasPhoto: Bool {
        return photoData != nil
    }
    
    var hasPose: Bool {
        return humanObservation != nil
    }
    
    func requestAccessAndSetup() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { _ in
                self.setup()
            }
        case .authorized:
            setup()
        default:
            print("Other status")
        }
    }
    
    private func setup() {
        session.beginConfiguration()
        session.sessionPreset = AVCaptureSession.Preset.photo
        do {
            guard let device = AVCaptureDevice.default(for: .video) else { return }
            let input = try AVCaptureDeviceInput(device: device)
            guard session.canAddInput(input) else { return }
            session.addInput(input)
            guard session.canAddOutput(output) else { return }
            session.addOutput(output)
            session.commitConfiguration()
            self.session.startRunning()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func takePhoto() {
        guard case .notStarted = photoCaptureState else { return }
        output.capturePhoto(with: AVCapturePhotoSettings(), delegate: self)
        withAnimation {
            self.photoCaptureState = .processing
        }
    }

    func retakePhoto() {
        session.startRunning()
        self.photoCaptureState = .notStarted
    }
    
    func runHumanBodyPoseRequestOnImage() {
            let request = VNDetectHumanBodyPoseRequest()
            let requestHandler = VNImageRequestHandler(data: self.photoData!)
            do {
                try requestHandler.perform([request])
                if let returnedObservation = request.results?.first {
                    Task { @MainActor in
                        self.humanObservation = returnedObservation
                    }
                }
            } catch {
                print("Unable to perform the request: \(error).")
            }
    }

    func convertPoseObservationToMLArray() -> MLMultiArray? {
        do {
            // Get the original pose points array
            guard let mlArray = try? humanObservation!.keypointsMultiArray() else {
                print("Error: Could not get keypointsMultiArray")
                return nil
            }
            
            // Create a new MLMultiArray with shape [30, 3, 18]
            let mlMultiArray = try MLMultiArray(shape: [30, 3, 18], dataType: .float32)
            
            // Fill MLMultiArray with repeated pose points
            for frameIndex in 0..<30 {
                // Copy the pose points to the corresponding frame
                for i in 0..<18 {
                    // Create an array of indices
                    let indices = [NSNumber(value: frameIndex), 0, NSNumber(value: i)]
                    // Assign value using subscript operator with array of indices
                    mlMultiArray[indices] = mlArray[[0, 0, NSNumber(value: i)]]
                    mlMultiArray[[NSNumber(value: frameIndex), 1, NSNumber(value: i)]] = mlArray[[0, 1, NSNumber(value: i)]]
                    mlMultiArray[[NSNumber(value: frameIndex), 2, NSNumber(value: i)]] = mlArray[[0, 2, NSNumber(value: i)]]
                }
            }
            
            return mlMultiArray
        } catch {
            print("Error creating MLMultiArray: \(error)")
            return nil
        }
    }

}

extension CameraViewModel: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let error = error {
            print(error.localizedDescription)
            return
        }
        
        guard let imageData = photo.fileDataRepresentation() else { return }
        
        Task(priority: .high) {
            self.session.stopRunning()
            await MainActor.run {
                withAnimation {
                    self.photoCaptureState = .finished(imageData)
                }
            }
        }
    }
}
