//
//  Copyright © 2020 Apparata AB. All rights reserved.
//

#if os(macOS)

import Cocoa
import SwiftUI

struct MacButton: NSViewRepresentable {
    
    enum KeyEquivalent: String {
        case escape = "\u{1b}"
        case `return` = "\r"
    }

    var title: String?
    var attributedTitle: NSAttributedString?
    var key: KeyEquivalent?
    let action: () -> Void

    init(title: String,
         key: KeyEquivalent? = nil,
         action: @escaping () -> Void) {
        self.title = title
        self.key = key
        self.action = action
    }

    init(attributedTitle: NSAttributedString,
         key: KeyEquivalent? = nil,
         action: @escaping () -> Void) {
        self.attributedTitle = attributedTitle
        self.key = key
        self.action = action
    }

    func makeNSView(context: NSViewRepresentableContext<Self>) -> NSButton {
        let button = NSButton(title: "", target: nil, action: nil)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setContentHuggingPriority(.defaultHigh, for: .vertical)
        button.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return button
    }

    func updateNSView(_ nsView: NSButton, context: NSViewRepresentableContext<Self>) {
        if attributedTitle == nil {
            nsView.title = title ?? ""
        }

        if title == nil {
            nsView.attributedTitle = attributedTitle ?? NSAttributedString(string: "")
        }

        nsView.keyEquivalent = key?.rawValue ?? ""

        nsView.onAction { _ in
            self.action()
        }
    }
}

private var controlActionClosureProtocolAssociatedObjectKey: UInt8 = 0

private protocol ControlActionClosureProtocol: NSObjectProtocol {
    var target: AnyObject? { get set }
    var action: Selector? { get set }
}

private final class ActionTrampoline<T>: NSObject {
    let action: (T) -> Void

    init(action: @escaping (T) -> Void) {
        self.action = action
    }

    @objc
    func action(sender: AnyObject) {
        action(sender as! T)
    }
}

extension ControlActionClosureProtocol {
    func onAction(_ action: @escaping (Self) -> Void) {
        let trampoline = ActionTrampoline(action: action)
        self.target = trampoline
        self.action = #selector(ActionTrampoline<Self>.action(sender:))
        objc_setAssociatedObject(self, &controlActionClosureProtocolAssociatedObjectKey, trampoline, .OBJC_ASSOCIATION_RETAIN)
    }
}

extension NSControl: ControlActionClosureProtocol {}

#endif

