//
//  SplashScreenView.swift
//  EatSideStory
//
//  Created by FrancoisW on 07/06/2024.
//

import SwiftUI
import AVKit

struct SplashScreenView: View {
    @Binding var isActive: Bool
    @State private var scale: CGFloat = 0.7
    
    var body: some View {
        ZStack{
            
            VideoPlayerView(name : Consts.UI.splashscreenName)
                .allowsHitTesting(false) // Disable user interaction (when thee user taps the screen, nothing happens)
             
            /*
            Image("TrafficRestoStill")
                .resizable()
                .ignoresSafeArea()

            */
            VStack {
//                   Spacer()
                ZStack {
//                    Color
//                        .white
//                        .opacity(0.3)
//                        .frame(width : 200,height : 200)
//                        .blur(radius: 10)
                    
                    
                    VStack {
                        Button(action: {
                            self.isActive = true
                        }) {
                            Image(Consts.UI.appLogo)
                                .resizable()
                                .aspectRatio(contentMode: .fill) // Set to .fill for cropping
                                .frame(width: 250, height: 250)
                                                        .padding(.top, -24)
                            // .clipped() // Crop to the specified frame
                            //  .opacity(0.7) // Adjust the opacity value (0.0 to 1.0)
                            //  .clipShape(Circle()) // Clip in a circle
                        }
                        
                        
                        Text("Version \(VersionHistory.current.version)")
                            .font(.caption)
                        //                        .padding(.top, 200)
                            .foregroundStyle(.white)
                            .fontWeight(.heavy)
                    }
                }
             //   .background(.ultraThinMaterial)

                Spacer() /*.frame(height: 400)*/
                
                Text("a c c e s s i b l e")
                    .foregroundStyle(.white)
//                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
//                    .font(.system(size: 36))
                    .font(.custom("SF Compact Rounded", size: 44))
                
//                Spacer()
            }
            .onTapGesture { // Detect tap to start editing
                self.isActive = true
            }
            .scaleEffect(scale)
            .onAppear {
                withAnimation(.easeIn(duration: 0.7)) {
                    self.scale = 0.9
                }
                
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
                withAnimation {
                    self.isActive = true
                }
            }
            
        }

    }
}


#Preview {
    struct PreviewWrapper: View {
        @State var isActive = false
        
        var body: some View {
            SplashScreenView(isActive : $isActive)
        }
    }
    return PreviewWrapper()
}

