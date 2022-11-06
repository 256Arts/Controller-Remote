//
//  UserDefaults.swift
//  Controller Remote
//
//  Created by Jayden Irwin on 2022-11-06.
//

import Foundation

extension UserDefaults {
    
    enum Key {
        static let cursorStyle = "cursorStyle"
        static let joystickSensitivity = "joystickSensitivity"
        static let dpadStepPreset = "dpadStepPreset"
        static let dpadStepVertical = "dpadStepVertical"
        static let dpadStepHorizontal = "dpadStepHorizontal"
    }
    
    func register() {
        register(defaults: [
            Key.cursorStyle: CursorStyle.default.rawValue,
            Key.joystickSensitivity: 4.0,
            Key.dpadStepPreset: DpadStepPreset.custom.rawValue,
            Key.dpadStepVertical: 100.0,
            Key.dpadStepHorizontal: 100.0
        ])
    }
    
}
