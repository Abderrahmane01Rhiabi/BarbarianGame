//
//  BarbarianService.swift
//  BarbarianGame
//
//  Created by tplocal on 12/12/2025.
//

import Foundation

// service pour gerer le barbare
class BarbarianService {
    
    // singleton
    static let shared = BarbarianService()
    
    private let networkManager = NetworkManager.shared
    
    private init() {}
    
    // recuperer mon barbare
    func getMyBarbarian() async throws -> Barbarian? {
        // l'api renvoie soit un barbare soit un tableau vide
        do {
            let barbarian: Barbarian = try await networkManager.get(
                endpoint: .getMyBarbarian
            )
            return barbarian
        } catch NetworkError.decodingError {
            // si decodage echoue c'est probablement un tableau vide
            // donc pas de barbare
            return nil
        } catch {
            throw error
        }
    }
    
    // recuperer un barbare par id
    func getBarbarian(id: Int) async throws -> Barbarian {
        let barbarian: Barbarian = try await networkManager.get(
            endpoint: .getBarbarian(id: id)
        )
        return barbarian
    }
    
    // recuperer la liste des avatars disponibles
    func getAvatars() async throws -> [Avatar] {
        let avatars: [Avatar] = try await networkManager.get(
            endpoint: .avatars
        )
        return avatars
    }
    
    // creer ou reinitialiser mon barbare
    func createBarbarian(name: String, avatarId: Int) async throws -> Barbarian {
        struct CreateBarbarianRequest: Codable {
            let name: String
            let avatarId: Int
            
            enum CodingKeys: String, CodingKey {
                case name
                case avatarId = "avatar_id"
            }
        }
        
        struct CreateBarbarianResponse: Codable {
            let status: String
        }
        
        let request = CreateBarbarianRequest(name: name, avatarId: avatarId)
        
        // appeler l'api de creation
        let response: CreateBarbarianResponse = try await networkManager.post(
            endpoint: .createBarbarian,
            body: request
        )
        
        print("barbare cree: \(response.status)")
        
        // recuperer le barbare cree
        guard let barbarian = try await getMyBarbarian() else {
            throw NetworkError.serverError("barbare cree mais impossible de le recuperer")
        }
        
        return barbarian
    }
    
    // depenser des points de competence
    func spendSkillPoints(attack: Int, defense: Int, precision: Int, evasion: Int) async throws{
        struct SpendPointsRequest: Codable {
            let attack: Int
            let defense: Int
            let precision: Int
            let evasion: Int
            
            enum CodingKeys: String, CodingKey {
                case attack
                case defense
                case precision = "accuracy"
                case evasion
            }
        }
        
        let request = SpendPointsRequest(
            attack: attack,
            defense: defense,
            precision: precision,
            evasion: evasion
        )
        
        let _: Barbarian = try await networkManager.post(
            endpoint: .spendSkillPoints,
            body: request
        )
    }
    
    // recuperer le leaderboard des barbares
    func fetchLeaderboard() async throws -> [LeaderboardEntry] {
        let entries: [LeaderboardEntry] = try await networkManager.get(
            endpoint: .leaderboard
        )
        return entries
    }
    
}


