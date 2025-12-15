//
//  Leaderboard.swift
//  BarbarianGame
//
//  Created by tplocal on 14/12/2025.
//

struct LeaderboardEntry: Codable, Identifiable {
    let id: Int
    let name: String
    let avatarId: Int
    let love: Int
    let exp: Int
    let attack: Int
    let defense: Int
    let accuracy: Int
    let evasion: Int
    
    enum CodingKeys: String, CodingKey {
        case id, name, love, exp, attack, defense, accuracy, evasion
        case avatarId = "avatar_id"
    }
}
