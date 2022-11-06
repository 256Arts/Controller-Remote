//
//  SettingsView.swift
//  Controller Remote
//
//  Created by Jayden Irwin on 2022-11-06.
//

import SwiftUI

struct SettingsView: View {
    
    @ObservedObject var inputController = InputController.shared
    
    @AppStorage(UserDefaults.Key.joystickSensitivity) var joystickSensitivity = 4.0
    @AppStorage(UserDefaults.Key.cursorStyle) var cursorStyleString = CursorStyle.default.rawValue
    @AppStorage(UserDefaults.Key.dpadStepPreset) var dpadStepPresetString = DpadStepPreset.custom.rawValue
    @AppStorage(UserDefaults.Key.dpadStepVertical) var dpadStepVertical = 100.0
    @AppStorage(UserDefaults.Key.dpadStepHorizontal) var dpadStepHorizontal = 100.0
    
    var cursorStyle: CursorStyle {
        CursorStyle(rawValue: cursorStyleString) ?? .default
    }
    var dpadStepPreset: DpadStepPreset {
        DpadStepPreset(rawValue: dpadStepPresetString) ?? .custom
    }
    
    var body: some View {
        VStack {
            GroupBox {
                Picker("Style", selection: $cursorStyleString) {
                    ForEach(CursorStyle.allCases) { preset in
                        Text(preset.rawValue)
                            .tag(preset.rawValue)
                    }
                }
                Slider(value: $joystickSensitivity, in: 1.0...10.0) {
                    Text("Joystick Sensitivity")
                }
            } label: {
                Text("Cursor")
            }
            
            GroupBox {
                Picker("Optimize For", selection: $dpadStepPresetString) {
                    ForEach(DpadStepPreset.allCases) { preset in
                        Text(preset.rawValue)
                            .tag(preset.rawValue)
                    }
                }
                HStack {
                    Text("Vertical Step")
                    Spacer()
                    TextField("Vertical Step", text: Binding(get: {
                        String(Int(dpadStepVertical))
                    }, set: { newValue in
                        if let newInt = Int(newValue) {
                            dpadStepVertical = CGFloat(newInt)
                        }
                    }))
                    .frame(width: 50)
                    Text("points")
                }
                .disabled(dpadStepPreset != .custom)
                HStack {
                    Text("Horizontal Step")
                    Spacer()
                    TextField("Horizontal Step", text: Binding(get: {
                        String(Int(dpadStepHorizontal))
                    }, set: { newValue in
                        if let newInt = Int(newValue) {
                            dpadStepHorizontal = CGFloat(newInt)
                        }
                    }))
                    .frame(width: 50)
                    Text("points")
                }
                .disabled(dpadStepPreset != .custom)
            } label: {
                Text("Dpad")
            }
        }
        .padding()
        .onChange(of: cursorStyleString, perform: { _ in
            updateCursorStyle()
        })
        .onChange(of: dpadStepPresetString) { _ in
            if dpadStepPreset != .custom {
                dpadStepVertical = dpadStepPreset.steps.height
                dpadStepHorizontal = dpadStepPreset.steps.width
            }
        }
        .onChange(of: dpadStepVertical) { _ in
            updateCursorStyle()
        }
        .onChange(of: dpadStepHorizontal) { _ in
            updateCursorStyle()
        }
    }
    
    func updateCursorStyle() {
        inputController.cursorController.updateStyle(size: CGSize(width: dpadStepHorizontal, height: dpadStepVertical))
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
