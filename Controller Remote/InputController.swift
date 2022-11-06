//
//  InputController.swift
//  Controller Remote
//
//  Created by Jayden Irwin on 2022-11-06.
//

import GameController

final class InputController: ObservableObject {
    
    static let shared = InputController()
    
    var cursorController = CursorController()
    
    var gameController: GCController? {
        GCController.current
    }
    
    var joystickSensitivity: CGFloat {
        UserDefaults.standard.double(forKey: UserDefaults.Key.joystickSensitivity)
    }
    var verticalStep: CGFloat {
        UserDefaults.standard.double(forKey: UserDefaults.Key.dpadStepVertical)
    }
    var horizontalStep: CGFloat {
        UserDefaults.standard.double(forKey: UserDefaults.Key.dpadStepHorizontal)
    }
    
    init() {
        NotificationCenter.default.addObserver(
            self, selector: #selector(self.handleControllerDidConnect),
            name: NSNotification.Name.GCControllerDidBecomeCurrent, object: nil)

        NotificationCenter.default.addObserver(
            self, selector: #selector(self.handleControllerDidDisconnect),
            name: NSNotification.Name.GCControllerDidStopBeingCurrent, object: nil)

        if let gc = GCController.current {
            registerGameController(gc)
        }
        
        cursorController.updateStyle(size: CGSize(width: horizontalStep, height: verticalStep))
        
        Timer.scheduledTimer(withTimeInterval: 0.01666, repeats: true) { _ in
            self.cursorController.cursor?.set()
            
            guard let gamepad = self.gameController?.extendedGamepad else { return }
            
            // Left Thumbstick
            let xValue = CGFloat(gamepad.leftThumbstick.xAxis.value) * self.joystickSensitivity
            let yValue = CGFloat(-gamepad.leftThumbstick.yAxis.value) * self.joystickSensitivity
            if 0 < abs(xValue) || 0 < abs(yValue) {
                self.cursorController.inputDelegateMove(CGSize(width: xValue, height: yValue))
            }
            
            // Right Thumbstick
            let yValue2 = CGFloat(gamepad.rightThumbstick.yAxis.value) * self.joystickSensitivity
            if 0 < abs(yValue2) {
                self.cursorController.inputDelegateScroll(yValue2)
            }
        }
    }

    @objc private func handleControllerDidConnect(_ notification: Notification) {
        guard let gameController = notification.object as? GCController else { return }
        unregisterGameController()
        registerGameController(gameController)
    }

    @objc private func handleControllerDidDisconnect(_ notification: Notification) {
        unregisterGameController()
    }

    func registerGameController(_ controller: GCController) {
        objectWillChange.send()
        guard let gamepad = controller.extendedGamepad else { return }

        weak var weakController = self

        // A B X
        gamepad.buttonA.pressedChangedHandler = { (button, _, isPressed) in
            guard let strongController = weakController else { return }
            if isPressed {
                strongController.cursorController.inputDelegateClick()
            }
        }
        gamepad.buttonB.pressedChangedHandler = { (button, _, isPressed) in
            guard let strongController = weakController else { return }
            if isPressed {
                strongController.cursorController.inputDelegateSecondaryClick()
            }
        }
        gamepad.buttonX.pressedChangedHandler = { (button, _, isPressed) in
            guard let strongController = weakController else { return }
            if isPressed {
                strongController.cursorController.inputDelegateClickAndTransferInputToApp()
            }
        }
        
        // Dpad
        gamepad.dpad.left.pressedChangedHandler = { (button, _, isPressed) in
            guard let strongController = weakController else { return }
            if isPressed {
                strongController.cursorController.inputDelegateMove(CGSize(width: -strongController.horizontalStep, height: 0))
            }
        }
        gamepad.dpad.right.pressedChangedHandler = { (button, _, isPressed) in
            guard let strongController = weakController else { return }
            if isPressed {
                strongController.cursorController.inputDelegateMove(CGSize(width: strongController.horizontalStep, height: 0))
            }
        }
        gamepad.dpad.up.pressedChangedHandler = { (button, _, isPressed) in
            guard let strongController = weakController else { return }
            if isPressed {
                strongController.cursorController.inputDelegateMove(CGSize(width: 0, height: -strongController.verticalStep))
            }
        }
        gamepad.dpad.down.pressedChangedHandler = { (button, _, isPressed) in
            guard let strongController = weakController else { return }
            if isPressed {
                strongController.cursorController.inputDelegateMove(CGSize(width: 0, height: strongController.verticalStep))
            }
        }
    }

    func unregisterGameController() {
        objectWillChange.send()
    }
    
}
