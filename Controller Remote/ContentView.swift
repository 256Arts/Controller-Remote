//
//  ContentView.swift
//  Controller Remote
//
//  Created by Jayden Irwin on 2022-11-05.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var inputController = InputController.shared
    
    var body: some View {
        VStack {
            Spacer()
            
            if let controller = inputController.gameController {
                Text("Connected to \(controller.vendorName ?? "gamepad")")
                    .font(.headline)
                Text("Keep this window on top to receive input.")
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)
            } else {
                Text("Connect a Gamepad")
            }
            
            if let gamepad = inputController.gameController?.extendedGamepad {
                GroupBox {
                    Grid {
                        GridRow {
                            HStack {
                                Image(systemName: gamepad.leftThumbstick.sfSymbolsName ?? "")
                                Image(systemName: gamepad.dpad.sfSymbolsName ?? "")
                            }
                            Text("Move Cursor")
                                .gridColumnAlignment(.leading)
                        }
                        GridRow {
                            Image(systemName: gamepad.rightThumbstick.sfSymbolsName ?? "")
                            Text("Scroll")
                        }
                        GridRow {
                            Image(systemName: gamepad.buttonA.sfSymbolsName ?? "")
                            Text("Click")
                        }
                        GridRow {
                            Image(systemName: gamepad.buttonB.sfSymbolsName ?? "")
                            Text("Secondary Click")
                        }
                        GridRow {
                            Image(systemName: gamepad.buttonX.sfSymbolsName ?? "")
                            Text("Click & Transfer Input To App")
                        }
                        if let buttonHome = gamepad.buttonHome {
                            GridRow {
                                Image(systemName: buttonHome.sfSymbolsName ?? "")
                                Text("Launchpad (Hold for App Switcher)")
                            }
                        }
                    }
                    .symbolVariant(.fill)
                    .imageScale(.large)
                    .frame(maxWidth: .infinity, alignment: .leading)
                } label: {
                    Text("Controls")
                }
            }
            
            Spacer()
            
            HStack {
                Link("Website", destination: URL(string: "https://www.jaydenirwin.com/")!)
                Link("Community", destination: URL(string: "https://www.256arts.com/joincommunity/")!)
                Link("Contribute", destination: URL(string: "https://github.com/256Arts/Controller-Remote")!)
            }
            .font(.footnote)
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
