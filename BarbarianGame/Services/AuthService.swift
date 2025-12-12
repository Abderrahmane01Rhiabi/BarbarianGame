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
    func register(username: String, password: String) async throws {
        let credentials = UserCredentials(username: username, password: password)
        let response: RegisterResponse = try await networkManager.post(
            endpoint: .register,
            body: credentials
        )
        
        print("inscription reussie: \(response.status)")
        
        // apres inscription il faut se connecter pour avoir le token
        let loginResponse = try await login(username: username, password: password)
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
        // essayer d'appeler l'api
        do {
            struct EmptyResponse: Codable {}
            let _: EmptyResponse = try await networkManager.post(endpoint: .logout)
        } catch {
            // si erreur api on l'ignore et on continue quand meme
            print("info: appel logout api echoue: \(error)")
        }
        
        // dans tous les cas supprimer le token local
        networkManager.clearAuthToken()
    }
    
    // verifier si connecte
    func isAuthenticated() -> Bool {
        // pour l'instant on verifie juste si on a un token
        // plus tard on pourra verifier si le token est valide
        return networkManager.hasAuthToken()
    }
}
