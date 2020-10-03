//
//  Copyright © 2020 Apparata AB. All rights reserved.
//

import SwiftUI
import Combine
import Lottie
import AppKit
import SwiftUIToolbox

enum LoopMode: String, Pickable {
    
    case playOnce = "Play Once"
    case loop = "Loop"
    case pingPong = "Ping Pong"

    var id: LoopMode { self }

    var description: String { return rawValue }
    
    var loopMode: LottieLoopMode {
        switch self {
        case .playOnce: return .playOnce
        case .loop: return .loop
        case .pingPong: return .autoReverse
        }
    }
}

struct LottieView: NSViewRepresentable {
    
    @EnvironmentObject var player: LottiePlayer
    
    func makeCoordinator() -> Coordinator {
        Coordinator(AnimationView())
    }
    
    var animation: Lottie.Animation?
        
    var loopMode: LoopMode
    
    class Coordinator: NSObject {

        var animationView: AnimationView
        
        var playerSubscription: AnyCancellable?
        
        init(_ animationView: AnimationView) {
            self.animationView = animationView
            super.init()
        }
        
        func subscribeToActions(from player: LottiePlayer) {
            playerSubscription = player.actions
                .sink { [weak self] action in
                    guard let animationView = self?.animationView else {
                        return
                    }
                    switch action {
                    case .playPause:
                        if animationView.isAnimationPlaying {
                            animationView.pause()
                            player.isPlaying = false
                        } else {
                            animationView.play(completion: { _ in
                                player.isPlaying = false
                            })
                            player.isPlaying = true
                        }
                    case .stop:
                        animationView.stop()
                        player.isPlaying = false
                    case .progress(let progress):
                        animationView.currentTime = progress
                        player.isPlaying = false
                    }
                }
        }
    }

    func makeNSView(context: NSViewRepresentableContext<LottieView>) -> NSView {
        let view = NSView()
        let animationView = context.coordinator.animationView
        animationView.animation = animation
        animationView.contentMode = .center

        animationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(animationView)
        NSLayoutConstraint.activate([
            animationView.topAnchor.constraint(equalTo: view.topAnchor),
            animationView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            animationView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            animationView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        context.coordinator.subscribeToActions(from: player)
        
        return view
    }

    func updateNSView(_ uiView: NSView, context: NSViewRepresentableContext<LottieView>) {
        let animationView = context.coordinator.animationView
        if animationView.animation !== animation {
            animationView.animation = animation
        }
        if animationView.loopMode != loopMode.loopMode {
            animationView.loopMode = loopMode.loopMode
        }
    }
}
