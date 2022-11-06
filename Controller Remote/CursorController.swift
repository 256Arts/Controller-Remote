//
//  CursorController.swift
//  Controller Remote
//
//  Created by Jayden Irwin on 2022-11-06.
//

import AppKit
import SwiftUI
import CoreGraphics

enum CursorStyle: String, CaseIterable, Identifiable {
    case `default` = "Default"
    case hand = "Hand"
    case box = "Box"
    
    var id: Self { self }
}

final class CursorController {
    
    var currentPosition: CGPoint {
        var position = NSEvent.mouseLocation
        position.y = NSHeight(NSScreen.screens.first!.frame) - position.y
        return position
    }
    var cursorStyle: CursorStyle {
        CursorStyle(rawValue: UserDefaults.standard.string(forKey: UserDefaults.Key.cursorStyle) ?? "") ?? .default
    }
    var cursor: NSCursor?
    
    func inputDelegateMove(_ delta: CGSize) {
        let newPosition = currentPosition.applying(.init(translationX: delta.width, y: delta.height))
        CGDisplayMoveCursorToPoint(CGMainDisplayID(), newPosition)
    }
    
    func inputDelegateScroll(_ delta: CGFloat) {
        let deltaPixels = Int32(delta)
        let event = CGEvent(scrollWheelEvent2Source: nil, units: .pixel, wheelCount: 1, wheel1: deltaPixels, wheel2: 0, wheel3: 0)
        event?.post(tap: .cghidEventTap)
    }
    
    func inputDelegateClick() {
        inputDelegateClickAndTransferInputToApp()
        NSApplication.shared.activate(ignoringOtherApps: true) // Take back input
    }
    
    func inputDelegateSecondaryClick() {
        let source = CGEventSource.init(stateID: .hidSystemState)
        let eventDown = CGEvent(mouseEventSource: source, mouseType: .rightMouseDown, mouseCursorPosition: currentPosition, mouseButton: .left)
        let eventUp = CGEvent(mouseEventSource: source, mouseType: .rightMouseUp, mouseCursorPosition: currentPosition, mouseButton: .left)
        eventDown?.post(tap: .cghidEventTap)
        usleep(50_000)
        eventUp?.post(tap: .cghidEventTap)
        NSApplication.shared.activate(ignoringOtherApps: true) // Take back input
    }
    
    func inputDelegateClickAndTransferInputToApp() {
        let source = CGEventSource.init(stateID: .hidSystemState)
        let eventDown = CGEvent(mouseEventSource: source, mouseType: .leftMouseDown, mouseCursorPosition: currentPosition, mouseButton: .left)
        let eventUp = CGEvent(mouseEventSource: source, mouseType: .leftMouseUp, mouseCursorPosition: currentPosition, mouseButton: .left)
        eventDown?.post(tap: .cghidEventTap)
        usleep(50_000)
        eventUp?.post(tap: .cghidEventTap)
    }
    
    func updateStyle(size: CGSize) {
        switch cursorStyle {
        case .default:
            cursor = nil
        case .hand:
            cursor = .pointingHand
        case .box:
            Task {
                cursor = await makeBoxCursor(size: size)
            }
        }
    }
    
    func makeBoxCursor(size: CGSize) async -> NSCursor? {
        let view = ZStack {
            RoundedRectangle(cornerRadius: 8).stroke(lineWidth: 2).foregroundColor(.black).padding(1)
            RoundedRectangle(cornerRadius: 8).stroke(lineWidth: 1).foregroundColor(.white).padding(1)
            Circle()
                .foregroundColor(.black)
                .frame(width: 3, height: 3)
            Circle()
                .foregroundColor(.white)
                .frame(width: 2, height: 2)
        }
            .frame(width: size.width, height: size.height)
        
        let renderer = await ImageRenderer(content: view)
        await MainActor.run {
            renderer.scale = 2
        }
        
        if let image = await renderer.nsImage {
            return NSCursor(image: image, hotSpot: NSPoint(x: size.width / 2, y: size.height / 2))
        } else {
            return nil
        }
    }
}
