//
//  Copyright © 2020 Apparata AB. All rights reserved.
//

import SwiftUI

struct AnimationFileRow<Content>: View where Content: View {
    
    let animationFile: AnimationFileViewModel
    
    let content: Content
    
    var body: some View {
        NavigationLink(destination: content
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        ) {
            HStack {
                Image("Document Icon")
                Text(animationFile.name)
                    .foregroundColor(Color.primary)
            }
        }
    }
    
    @inlinable
    init(animationFile: AnimationFileViewModel, @ViewBuilder content: () -> Content) {
        self.animationFile = animationFile
        self.content = content()
    }
}
