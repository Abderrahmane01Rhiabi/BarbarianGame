//
//  CombatService.swift
//  BarbarianGame
//
//  Created by tplocal on 12/12/2025.
//
import Foundation

class CombatService {
    static let shared = CombatService()
    
    private let networkManager = NetworkManager.shared
    
    private init() {}
    
    func fight() async throws -> Fight {
            do {
                let result: Fight = try await networkManager.post(
                    endpoint: .fight
                )
                return result
            }
            //Renvoie Erreur 429 si on demande un combat dans un délais court
            catch NetworkError.waitdelay {
                throw NetworkError.waitdelay
            } catch {
                throw error
            }
        }
    
    // recuperer les combats
    func getMyFights() async throws -> [FightHistory] {
        do {
            let fights: [FightHistory] = try await networkManager.get(
                endpoint: .myFights
            )
            return fights
        } catch {
            throw error
        }
    }
    
}
