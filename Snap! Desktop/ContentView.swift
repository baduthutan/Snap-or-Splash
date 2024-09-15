//
//  ContentView.swift
//  Snap! Desktop
//
//  Created by vin chen on 21/05/24.
//

import SwiftUI
import CoreML

//struct ContentView: View {
//    @State private var imageData: URL? = nil
//    @State private var showCamera: Bool = false
//
//
//    var body: some View {
//        VStack {
//            if let imageData = imageData, let nsImage = NSImage(data: imageData) {
//                Image(nsImage: nsImage)
//                    .resizable()
//                    .scaledToFit()
//            } else {
//                Image(systemName: "photo")
//                    .resizable()
//                    .scaledToFit()
//                    .foregroundStyle(.gray)
//            }
//
//            Button("Take Photo") {
//                showCamera = true
//            }
//            .padding()
//        }
//        .padding()
//        .fullScreenCamera(isPresented: $showCamera, imageData: $imageData)
//
//    }
//}

struct ContentView: View {
    var body: some View {
              mainmenuView()
    }
}

#Preview {
    ContentView()
}
