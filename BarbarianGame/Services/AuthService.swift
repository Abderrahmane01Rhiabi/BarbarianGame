//
//  AuthService.swift
//  BarbarianGame
//
//  Created by tplocal on 08/12/2025.
//

import Foundation

// service d'authentification
class AuthService {
    
    // singleton
    static let shared = AuthService()
    
    private let networkManager = NetworkManager.shared
    
    private init() {}
    
    // inscription
    func register(username: String, password: String) async throws -> AuthResponse {
        let credentials = UserCredentials(username: username, password: password)
        let response: AuthResponse = try await networkManager.post(
            endpoint: .register,
            body: credentials
        )
        
        // sauvegarder le token
        networkManager.setAuthToken(response.token)
        
        return response
    }
    
    // connexion
    func login(username: String, password: String) async throws -> AuthResponse {
        let credentials = UserCredentials(username: username, password: password)
        let response: AuthResponse = try await networkManager.post(
            endpoint: .login,
            body: credentials
        )
        
        // sauvegarder le token
        networkManager.setAuthToken(response.token)
        
        return response
    }
    
    // deconnexion
    func logout() async throws {
        // appeler l'api pour invalider le token
        struct EmptyResponse: Codable {}
        let _: EmptyResponse = try await networkManager.post(endpoint: .logout)
        
        // supprimer le token local
        networkManager.clearAuthToken()
    }
    
    // verifier si connecte
    func isAuthenticated() -> Bool {
        // pour l'instant on verifie juste si on a un token
        // plus tard on pourra verifier si le token est valide
        return networkManager.hasAuthToken()
    }
}
