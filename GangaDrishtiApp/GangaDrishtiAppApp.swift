//
//  GangaDrishtiAppApp.swift
//  GangaDrishtiApp
//
//  Created by Yaduraj Singh on 15/09/25.
//

import SwiftUI

@main
struct GangaDrishtiAppApp: App {
    @State private var showSplash = true
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                if showSplash {
                    SplashScreenView()
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
                                withAnimation {
                                    showSplash = false
                                }
                            }
                        }
                } else {
                    ContentView()
                }
            }
        }
    }
}
