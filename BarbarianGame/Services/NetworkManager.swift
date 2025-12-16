//
//  NetworkManager.swift
//  BarbarianGame
//
//  Created by tplocal on 08/12/2025.
//

import Foundation

// gestion des erreurs reseau
enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError
    case serverError(String)
    case unauthorized
    case waitdelay
    case erreur400
    case erreur404
    case erreur403
}

// gestionnaire principal des requetes http
class NetworkManager {
    
    // singleton
    static let shared = NetworkManager()
    
    // token d'authentification
    private var authToken: String?
    
    private init() {}
    
    // sauvegarder le token
    func setAuthToken(_ token: String) {
        self.authToken = token
    }
    
    // supprimer le token
    func clearAuthToken() {
        self.authToken = nil
    }
    
    // verifier si un token existe
    func hasAuthToken() -> Bool {
        return authToken != nil
    }
    
    // requete get generique
    func get<T: Decodable>(endpoint: APIConfig.Endpoint) async throws -> T {
        guard let url = endpoint.url else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // ajouter le token si disponible
        if let token = authToken {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        let (data, response) = try await URLSession.shared.data(for: request)
        try validateResponse(response, data: data)
        
        do {
            let decoded = try JSONDecoder().decode(T.self, from: data)
            return decoded
        } catch {
            throw NetworkError.decodingError
        }
    }
    
    // requete post generique
    func post<T: Decodable, B: Encodable>(endpoint: APIConfig.Endpoint, body: B) async throws -> T {
        guard let url = endpoint.url else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // ajouter le token si disponible
        if let token = authToken {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        // encoder le body en json
        request.httpBody = try JSONEncoder().encode(body)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        try validateResponse(response, data: data)
        
        do {
            let decoded = try JSONDecoder().decode(T.self, from: data)
            return decoded
        } catch {
            throw NetworkError.decodingError
        }
    }
    
    // requete post sans body
    func post<T: Decodable>(endpoint: APIConfig.Endpoint) async throws -> T {
        guard let url = endpoint.url else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let token = authToken {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        let (data, response) = try await URLSession.shared.data(for: request)
        try validateResponse(response, data: data)
        do {
            let decoded = try JSONDecoder().decode(T.self, from: data)
            return decoded
        } catch {
            throw NetworkError.decodingError
        }
    }
    
    // validation de la reponse http
    private func validateResponse(_ response: URLResponse, data: Data) throws {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.serverError("invalid response")
        }
        
        switch httpResponse.statusCode {
        case 200...299:
            return
        case 400:
            throw NetworkError.erreur400
        case 401:
            throw NetworkError.unauthorized
        case 403:
            throw NetworkError.erreur403
        case 404:
            throw NetworkError.erreur404
        case 429 :
            throw NetworkError.waitdelay
        default:
            if let errorMessage = String(data: data, encoding: .utf8) {
                throw NetworkError.serverError(errorMessage)
            }
            throw NetworkError.serverError("status code: \(httpResponse.statusCode)")
        }
    }
}
