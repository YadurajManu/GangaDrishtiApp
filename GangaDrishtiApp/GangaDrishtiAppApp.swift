//
//  GangaDrishtiAppApp.swift
//  GangaDrishtiApp
//
//  Created by Yaduraj Singh on 15/09/25.
//

import SwiftUI
import FirebaseCore

@main
struct GangaDrishtiAppApp: App {
    @State private var showSplash = true
    
    init() {
        FirebaseApp.configure()
    }
    
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
