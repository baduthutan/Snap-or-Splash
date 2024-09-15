//
//  mainmenuView.swift
//  Snap! Desktop
//
//  Created by vin chen on 27/05/24.
//

import SwiftUI

struct mainmenuView: View {
    @State private var shouldNavigate: Bool = false
    var body: some View {
        if !shouldNavigate{
            ZStack{
                Image("backgroundMain")
                    .resizable()
                    .scaledToFill()
                    .foregroundStyle(.gray)
                VStack{
                    Spacer()
                    Button(action: {
                         shouldNavigate = true
                    }) {
                        Image("buttonMain")
                            .resizable()
                            .scaledToFill()
                    }
                    .frame(width: 300, alignment: .bottom)
                    .padding(.bottom, 80)
                    
                }
                
            }
        } else {
            tutorView()
        }
        
    }
}

#Preview {
    mainmenuView()
}
