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
            }
            catch NetworkError.erreur400{ // Aucun barbare ou adversaire trouvé
                throw NetworkError.erreur400
            }
            catch {
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
        }
        catch NetworkError.erreur403{ // Erreur d'un combat qui concerne pas le joueur
            throw NetworkError.erreur403
        }
        catch NetworkError.erreur404{// Combat introuvable
            throw NetworkError.erreur404
        }
        catch {
            throw error
        }
    }
    
}
