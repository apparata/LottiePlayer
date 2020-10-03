//
//  Copyright © 2020 Apparata AB. All rights reserved.
//

import Foundation
import SwiftUIToolbox
import Lottie

struct AnimationFileViewModel: Identifiable, Hashable, SearchFilterable {

    var id: UUID {
        animationFile.id
    }
    
    var name: String {
        animationFile.name
    }
    
    var animation: Lottie.Animation {
        animationFile.animation
    }
    
    private var animationFile: AnimationFile
    
    init(animationFile: AnimationFile) {
        self.animationFile = animationFile
    }
    
    func isMatch(for searchString: String) -> Bool {
        return name.lowercased().contains(searchString)
    }
}
