//
//  Copyright © 2020 Apparata AB. All rights reserved.
//

import SwiftUI
import Lottie
import SwiftUIToolbox

struct LottieUI: View {
    
    @EnvironmentObject var player: LottiePlayer
    
    @State var backgroundColor: SwiftUI.Color = Color(NSColor.controlBackgroundColor)
        
    var animation: Lottie.Animation
    
    @State var loopMode: LoopMode = .playOnce
        
    var durationRange: ClosedRange<TimeInterval> {
        0...animation.duration
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                LottieView(animation: animation, loopMode: loopMode)
                    .background(backgroundColor)
            }
            
            VStack(spacing: 4) {
                HStack {
                    Slider(value: $player.progress, in: durationRange)
                        .frame(height: 30)
                        .padding(.horizontal)
                        .padding(.vertical, 4)
                }
                HStack {
                    Button("􀊈", action: playPauseAnimation)
                    Button("􀛷", action: stopAnimation)
                        .disabled(!player.isPlaying)
                    EnumPicker("", selection: $loopMode)
                        .frame(width: 110)
                    Spacer()
                    if let animation = animation {
                        TextField("", text: $player.progressString)
                            .font(.system(size: 13, weight: .regular, design: .monospaced))
                            .multilineTextAlignment(.trailing)
                            .frame(width: 56)
                        Text(String(format: "/ %.2f", animation.duration))
                            .font(.system(size: 13, weight: .regular, design: .monospaced))
                            .multilineTextAlignment(.trailing)
                            .frame(width: 66)
                        /*
                        Text("\(String(format: "%.2f", animation.duration))s  @  \(Int(animation.size.width))x\(Int(animation.size.height))")*/
                    }
                    Spacer()
                    Group {
                        ColorButton(.red, color: $backgroundColor)
                        ColorButton(.green, color: $backgroundColor)
                        ColorButton(.black, color: $backgroundColor)
                        ColorButton(Color(.sRGB, white: 0.2, opacity: 1), color: $backgroundColor)
                        ColorButton(Color(.sRGB, white: 0.4, opacity: 1), color: $backgroundColor)
                        ColorButton(Color(.sRGB, white: 0.8, opacity: 1), color: $backgroundColor)
                        ColorButton(.white, color: $backgroundColor)
                    }
                }.padding([.horizontal, .bottom])
            }.background(Color(NSColor.windowBackgroundColor))
        }
    }
    
    private func playPauseAnimation() {
        player.playPause()
    }
    
    private func stopAnimation() {
        player.stop()
    }
}
