//
//  Fight.swift
//  BarbarianGame
//
//  Created by tplocal on 07/12/2025.
//

import Foundation

// un combat complet entre deux barbares
struct Fight: Codable, Identifiable {
    
    let id: Int
    let initiatorId: Int
    let opponentId: Int
    let winnerId: Int
    let expGained: Int
    let timestamp: String
    let rounds: [FightRound]?
    
    // mappage json
    enum CodingKeys: String, CodingKey {
        case id
        case initiatorId = "initiator_id"
        case opponentId = "opponent_id"
        case winnerId = "winner_id"
        case expGained = "exp_gained"
        case timestamp
        case rounds
    }
}

// un round individuel dans un combat
struct FightRound: Codable, Identifiable {
    
    let round: Int
    let attackerId: Int
    let attackerName: String
    let defenderId: Int
    let defenderName: String
    let hit: Bool
    let damage: Int
    let defenderHp: Int
    
    // id pour swiftui list
    var id: Int { round }
    
    // mappage json
    enum CodingKeys: String, CodingKey {
        case round
        case attackerId = "attacker_id"
        case attackerName = "attacker_name"
        case defenderId = "defender_id"
        case defenderName = "defender_name"
        case hit
        case damage
        case defenderHp = "defender_hp"
    }
}

// fonctions pratiques
extension Fight {
    
    // est-ce que mon barbare a gagne
    func didIWin(myBarbarianId: Int) -> Bool {
        return winnerId == myBarbarianId
    }
    
    // est-ce que j'ai initie ce combat
    func didIInitiate(myBarbarianId: Int) -> Bool {
        return initiatorId == myBarbarianId
    }
    
    // id de mon adversaire
    func getOpponentId(myBarbarianId: Int) -> Int {
        return initiatorId == myBarbarianId ? opponentId : initiatorId
    }
}

extension FightRound {
    
    // texte descriptif du round
    var description: String {
        if hit {
            return "\(attackerName) frappe \(defenderName) pour \(damage) degats"
        } else {
            return "\(defenderName) esquive l'attaque de \(attackerName)"
        }
    }
}
