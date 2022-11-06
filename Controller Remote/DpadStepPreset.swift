//
//  DpadStepPreset.swift
//  Controller Remote
//
//  Created by Jayden Irwin on 2022-11-06.
//

import Foundation

enum DpadStepPreset: String, CaseIterable, Identifiable {
    case dolphin = "Dolphin Gird"
    case shortcuts = "Shortcuts Grid"
    case custom = "Custom"
    
    var id: Self { self }
    var steps: CGSize {
        switch self {
        case .dolphin:
            return CGSize(width: 170, height: 246)
        case .shortcuts:
            return CGSize(width: 148.5, height: 106)
        case .custom:
            return CGSize(width: 100, height: 100)
        }
    }
}
