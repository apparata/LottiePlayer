//
//  Copyright © 2020 Apparata AB. All rights reserved.
//

import SwiftUI
import Combine
import Lottie

extension MainView: DropDelegate {

    /// Called when a drop, which has items conforming to any of the types
    /// passed to the onDrop() modifier, enters an onDrop target.
    func validateDrop(info: DropInfo) -> Bool {
        return true
    }

    /// Tells the delegate it can request the item provider data from the
    /// DropInfo incorporating it into the application's data model as
    /// appropriate. This function is required.
    ///
    /// Return `true` if the drop was successful, `false` otherwise.
    func performDrop(info: DropInfo) -> Bool {
        
        let itemProviders = info.itemProviders(for: [(kUTTypeFileURL as String)])
        
        if itemProviders.isEmpty {
            return false
        }
        
        self.animationFiles.loadFromItemProviders(itemProviders)
        
        return true
    }
    
    func dropEntered(info: DropInfo) {
        print("Drop entered!")
    }

    /// Called as a validated drop moves inside the onDrop modified view.
    ///
    /// Return a drop proposal that contains the operation the delegate intends
    /// to perform at the DropInfo.location, The default implementation returns
    /// nil, which tells the drop to use that last valid returned value or else
    /// .copy.
    func dropUpdated(info: DropInfo) -> DropProposal? {
        return nil
    }

    /// Tells the delegate a validated drop operation has exited the onDrop
    /// modified view. The default behavior does nothing.
    func dropExited(info: DropInfo) {
        print("Drop exited!")
    }
}
