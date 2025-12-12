//
//  AuthManager.swift
//  BarbarianGame
//
//  Created by tplocal on 12/12/2025.
//

import Foundation
import SwiftUI

// gestionnaire global de l'authentification
class AuthManager: ObservableObject {
    
    // singleton
    static let shared = AuthManager()
    
    // etat de connexion observable
    @Published var isAuthenticated: Bool = false
    
    private init() {
        // verifier si on a un token au demarrage
        checkAuthStatus()
    }
    
    // verifier l'etat d'authentification
    func checkAuthStatus() {
        isAuthenticated = AuthService.shared.isAuthenticated()
    }
    
    // connexion reussie
    func login() {
        isAuthenticated = true
    }
    
    // deconnexion
    func logout() async {
        do {
            try await AuthService.shared.logout()
        } catch {
            print("erreur logout: \(error)")
        }
        
        // dans tous les cas deconnecter
        await MainActor.run {
            isAuthenticated = false
        }
    }
}
