//
//  tutorView.swift
//  Snap! Desktop
//
//  Created by vin chen on 27/05/24.
//

import SwiftUI

struct tutorView: View {
    @State private var imageData: Data? = nil
    @State private var showCamera: Bool = false
    @State private var armflexProb: Double = 0.0
    @State private var shouldNavigate: Bool = false
    @State private var shouldBack: Bool = false
 
    var body: some View {
                if !shouldNavigate{
                    rootView()
                } else {
                    destinationView()
                }
    }
    private func rootView() -> some View {
        VStack {
            ZStack{
                Image("backgroundTutor")
                    .resizable()
                    .scaledToFill()
                    .foregroundStyle(.gray)
                VStack{
                    Spacer()
                    Button(action: {
                         showCamera = true
                    }) {
                        Image("buttonReady")
                            .resizable()
                            .scaledToFill()
                    }
                    .frame(width: 300, alignment: .bottom)
                    .padding(.bottom, 80)
                    
                }
            }
            
            NavigationLink(
                destination: destinationView(),
                isActive: $shouldNavigate,
                label: {
                    EmptyView()
                })
                .hidden()
            
        }
        .padding()
        .sheet(isPresented: $showCamera) {
            CameraView(imageData: $imageData, showCamera: $showCamera, armflexProb: $armflexProb, shouldNavigate: $shouldNavigate)
                .frame(width: 1700, height: 1050)
        }
        }

    private func destinationView() -> some View {
        if armflexProb > 0.01 && armflexProb < 0.75 {
            return AnyView(endView(armflexProb: armflexProb, background: "backgroundBad"))
        } else if armflexProb <= 1.0 && armflexProb > 0.75 {
            return AnyView(endView(armflexProb: armflexProb , background: "backgroundGood"))
        } else if armflexProb == 0.0  {
            return AnyView(endView(armflexProb: armflexProb,background: "backgroundError"))
        } else{
            return AnyView(endView(armflexProb: armflexProb, background: "backgroundError"))
        }
    }
}
    struct endView: View {
        let armflexProb: Double
        let background: String
        @State private var shouldBack: Bool = false
        var body: some View {
            if !shouldBack{
                ZStack{
                    Image(background)
                        .resizable()
                        .scaledToFill()
                    VStack{
                        Spacer()
                        Text("Score: \(Int(armflexProb*100))")
                            
                            .foregroundColor(.black)
                            .font(.system(size: 36))
                        Button(action: {
                             shouldBack = true
                        }) {
                            Image("buttonBack")
                                .resizable()
                                .scaledToFill()
                        }
                        .frame(width: 150, alignment: .bottom)
                        .padding(.bottom, 220)
                    }
                }

            } else{
                mainmenuView()
            }
        }
    }


#Preview {
    endView(armflexProb: 0.2, background: "backgroundBad")
}
