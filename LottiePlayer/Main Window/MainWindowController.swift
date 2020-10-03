//
//  Copyright © 2020 Apparata AB. All rights reserved.
//

import Cocoa
import SwiftUI

class MainWindowController: NSWindowController, NSToolbarDelegate {

    private var toolbar: NSToolbar!
    
    private var windowState: MainWindowState!
    
    private var animationFiles: AnimationFilesModel!
    
    convenience init() {
                
        let window = Self.makeWindow()
        
        window.backgroundColor = NSColor.controlBackgroundColor
        
        self.init(window: window)

        animationFiles = AnimationFilesModel(animationFiles: [])
        
        let contentView = makeMainView(animationFiles)
            .environmentObject(AnimationFilesViewModel(animationFilesModel: animationFiles))
            .environmentObject(LottiePlayer())
        
        window.titleVisibility = .hidden
        window.center()
        window.title = "Lottie Player"
        window.contentView = NSHostingView(rootView: contentView)
        window.setFrameAutosaveName("LottiePlayerMainAppWindow")
        window.titlebarAppearsTransparent = true

        //toolbar = makeToolbar()
        //window.toolbar = toolbar
    }
    
    private static func makeWindow() -> NSWindow {
        let contentRect = NSRect(x: 0, y: 0, width: 720, height: 360)
        let styleMask: NSWindow.StyleMask = [
            .titled,
            .closable,
            .miniaturizable,
            .resizable,
            .fullSizeContentView
        ]
        return NSWindow(contentRect: contentRect,
                        styleMask: styleMask,
                        backing: .buffered,
                        defer: false)
    }
    
    private func makeMainView(_ animationFiles: AnimationFilesModel) -> some View {
        MainView(animationFiles: animationFiles)
            .frame(minWidth: 720, minHeight: 360)
            .edgesIgnoringSafeArea(.all)
    }

    private func makeToolbar() -> NSToolbar {
        toolbar = NSToolbar(identifier: "LottiePlayer.LottiePlayerMainAppWindowToolbar")
        toolbar.allowsUserCustomization = false
        toolbar.autosavesConfiguration = false
        toolbar.displayMode = .iconOnly
        toolbar.showsBaselineSeparator = false
        toolbar.delegate = self
        return toolbar
    }
        
    @objc
    public func refreshAction(_ sender: Any?) {
        print("Refresh!")
    }
    
    // MARK: - NSToolbarDelegate
    
    public func toolbar(_ toolbar: NSToolbar, itemForItemIdentifier itemIdentifier: NSToolbarItem.Identifier, willBeInsertedIntoToolbar flag: Bool) -> NSToolbarItem? {
        
        var toolbarItem: NSToolbarItem
        
        switch itemIdentifier {
        case .refreshItem:
            toolbarItem = NSToolbarItem(id: .refreshItem,
                                        target: self,
                                        selector: #selector(refreshAction(_:)),
                                        label: "Refresh",
                                        image: NSImage(requiredNamed: NSImage.refreshTemplateName),
                                        toolTip: "Refresh")
        case NSToolbarItem.Identifier.flexibleSpace:
            toolbarItem = NSToolbarItem(itemIdentifier: itemIdentifier)
        default:
            fatalError()
        }
        
        return toolbarItem
    }
    
    public func toolbarAllowedItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        return [
            .flexibleSpace,
            .refreshItem
        ]
    }
    
    public func toolbarDefaultItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        return [
            .flexibleSpace,
            .flexibleSpace,
            .refreshItem
        ]
    }
}

private extension NSToolbarItem.Identifier {
    static let refreshItem = NSToolbarItem.Identifier("refresh")
}
