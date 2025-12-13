//
//  Fight.swift
//  BarbarianGame
//
//  Created by tplocal on 07/12/2025.
//

import Foundation


// reponse de l'historique des combats
struct FightHistory: Codable, Identifiable {
    let id: Int
    let attackerId: Int
    let defenderId: Int
    let winnerId: Int
    let createdAt: String
    let expAttacker: Int
    let expDefender: Int
    let log: FightLog
    
    enum CodingKeys: String, CodingKey {
        case id
        case attackerId = "attacker_id"
        case defenderId = "defender_id"
        case winnerId = "winner_id"
        case createdAt = "created_at"
        case expAttacker = "exp_attacker"
        case expDefender = "exp_defender"
        case log
    }
}

// extensions pour faciliter l'utilisation
extension FightHistory {
    
    // exp gagnee par mon barbare
    func expGained(myBarbarianId: Int) -> Int {
        return attackerId == myBarbarianId ? expAttacker : expDefender
    }
    
    // est ce que j'ai gagne
    func didIWin(myBarbarianId: Int) -> Bool {
        return winnerId == myBarbarianId
    }
    
    // id de l'adversaire
    func opponentId(myBarbarianId: Int) -> Int {
        return attackerId == myBarbarianId ? defenderId : attackerId
    }
    
    // est ce que j'ai initie le combat
    func didIInitiate(myBarbarianId: Int) -> Bool {
        return attackerId == myBarbarianId
    }
}

// un combat complet entre deux barbares
struct Fight: Codable {
    
    let opponent : Barbarian
    let winnerId: Int
    let expGained: Int
    let log: FightLog
    
    // mappage json
    enum CodingKeys: String, CodingKey {
        case opponent
        case winnerId = "winner_id"
        case expGained = "exp_gain"
        case log
    }
}

struct FightLog: Codable {
    let attackerId: Int
    let defenderId: Int
    let rounds: [FightRound]?
    let winnerId: Int

    enum CodingKeys: String, CodingKey {
        case attackerId = "attacker_id"
        case defenderId = "defender_id"
        case rounds
        case winnerId = "winner_id"
    }
}
// un round individuel dans un combat
struct FightRound: Codable, Identifiable {
    
    let round: Int
    let actor: Int
    let target: Int
    let hit: Bool
    let damage: Int
    let hpTargetAfter: Int
    
    // id pour swiftui list, l'id du round correspond au numéro du round et l'id de l'attaquant
    var id: String { "\(round)-\(actor)" }

    
    // mappage json
    enum CodingKeys: String, CodingKey {
        case round
        case actor
        case target
        case hit
        case damage
        case hpTargetAfter = "hp_target_after"
    }
}

// fonctions pratiques
extension Fight {
    
    // est-ce que mon barbare a gagne
    func didIWin(myBarbarianId: Int) -> Bool {
        return winnerId == myBarbarianId
    }
    
    // id de mon adversaire
    func getOpponentId() -> Int {
        return opponent.id
    }
}

extension FightLog{
    
    // est-ce que j'ai initie ce combat
    func didIInitiate(myBarbarianId: Int) -> Bool {
        return attackerId == myBarbarianId
    }
}

extension FightRound {
    
    // texte descriptif du round
    func description(myBarbarian : Barbarian, opponent : Barbarian)-> String {
        if actor == myBarbarian.id{
            if hit  {
                return "\(myBarbarian.name) frappe \(opponent.name) pour \(damage) degats"
            } else {
                return "\(opponent.name) esquive l'attaque de \(myBarbarian.name)"
            }
        }
        else {
            if hit  {
                return "\(opponent.name) frappe \(myBarbarian.name) pour \(damage) degats"
            } else {
                return "\(myBarbarian.name) esquive l'attaque de \(opponent.name)"
            }
        }

    }
}
