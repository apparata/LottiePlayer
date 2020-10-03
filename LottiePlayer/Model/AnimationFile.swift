//
//  Copyright © 2020 Apparata AB. All rights reserved.
//

import Foundation
import Lottie

struct AnimationFile: Identifiable, Hashable {
    var id: UUID = UUID()
    var name: String
    var animation: Lottie.Animation
}

extension Lottie.Animation: Hashable {
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(duration)
        hasher.combine(startFrame)
        hasher.combine(endFrame)
        hasher.combine(framerate)
        hasher.combine(markerNames)
    }
    
    public static func == (lhs: Lottie.Animation, rhs: Lottie.Animation) -> Bool {
        lhs.duration == rhs.duration
            && lhs.startFrame == rhs.startFrame
            && lhs.endFrame == rhs.endFrame
            && lhs.framerate == rhs.framerate
            && lhs.markerNames == rhs.markerNames
    }
}
