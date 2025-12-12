//
//  Barbarian.swift
//  BarbarianGame
//
//  Created by tplocal on 07/12/2025.
//

import Foundation

// un barbare avec toutes ses statistiques
struct Barbarian: Codable, Identifiable {
    
    // identite
    let id: Int
    let name: String
    let avatarId: Int?
    
    // progression
    let love: Int
    let exp: Int
    let skillPoints: Int
    
    // statistiques de combat
    let attack: Int
    let defense: Int
    let precision: Int
    let evasion: Int
    
    // points de vie
    let maxHp: Int
    
    // hp calcule (par defaut = maxHp)
    var hp: Int {
        return maxHp
    }
    
    // mappage json
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case avatarId = "avatar_id"
        case love
        case exp
        case skillPoints = "skill_points"
        case attack
        case defense
        case precision = "accuracy"
        case evasion
        case maxHp = "hp_max"
    }
}
