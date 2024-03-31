//
//  SetGameApp.swift
//  SetGame
//
//  Created by Matthew Braniff on 3/27/24.
//

import SwiftUI

@main
struct SetGameApp: App {
    @StateObject var setGameViewModel = SetGameViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: setGameViewModel)
        }
    }
}
