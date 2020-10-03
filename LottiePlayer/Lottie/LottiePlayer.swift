//
//  Copyright © 2020 Apparata AB. All rights reserved.
//

import Foundation
import Combine

enum LottieAction {
    case playPause
    case stop
    case progress(TimeInterval)
}

class LottiePlayer: ObservableObject {
    
    @Published var isPlaying: Bool = false
        
    var progressString: String = "0.00" {
        didSet {
            guard let newProgress = TimeInterval(progressString) else {
                return
            }
            let progressAsString = formatTime(time: progress)
            if progressString != progressAsString {
                progress = newProgress
            }
            progress = TimeInterval(progressString) ?? 0
            actions.send(.progress(progress))
        }
    }
    
    var progress: TimeInterval = 0 {
        didSet {
            let string = formatTime(time: progress)
            if string != progressString {
                progressString = string
            }
            actions.send(.progress(progress))
            objectWillChange.send()
        }
    }
        
    let actions = PassthroughSubject<LottieAction, Never>()
    
    func playPause() {
        actions.send(.playPause)
    }
    
    func stop() {
        actions.send(.stop)
    }
     
    private func formatTime(time: Double) -> String {
        return String(format: "%.2f", time)
    }
}
