//
//  BarbarianGameApp.swift
//  BarbarianGame
//
//  Created by tplocal on 07/12/2025.
//

import SwiftUI

@main
struct BarbarianGameApp: App {
    
    // observer l'etat d'authentification
    @StateObject private var authManager = AuthManager.shared
    
    var body: some Scene {
        WindowGroup {
            if authManager.isAuthenticated {
                HomeView()
            } else {
                LoginView()
            }
        }
    }
}
