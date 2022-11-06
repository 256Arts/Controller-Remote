//
//  Controller_RemoteApp.swift
//  Controller Remote
//
//  Created by Jayden Irwin on 2022-11-05.
//

import AppKit
import SwiftUI

@main
struct Controller_RemoteApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .frame(minWidth: 340, maxWidth: 340, minHeight: 260, maxHeight: 260)
        }
        .windowResizability(.contentSize)
        .commandsReplaced { }
        
        Settings {
            SettingsView()
        }
    }
    
    init() {
        UserDefaults.standard.register()
    }
}
