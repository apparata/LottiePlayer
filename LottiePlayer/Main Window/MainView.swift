//
//  Copyright © 2020 Apparata AB. All rights reserved.
//

import SwiftUI

struct MainView: View {
    
    var animationFiles: AnimationFilesModel
    
    @EnvironmentObject var animationsViewModel: AnimationFilesViewModel
    
    var body: some View {
        MainSplitView()
            .layoutPriority(1.0)
            .onDrop(of: [(kUTTypeFileURL as String)], delegate: self)
    }
}
