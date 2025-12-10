//
//  APIConfig.swift
//  BarbarianGame
//
//  Created by tplocal on 08/12/2025.
//

import Foundation

// configuration de l'api
enum APIConfig {
    
    // url de base
    static let baseURL = "https://vps.vautard.fr/barbarians/ws"
    
    // endpoints
    enum Endpoint {
        case login
        case register
        case logout
        case getMyBarbarian
        case getBarbarian(id: Int)
        case createBarbarian
        case avatars
        case spendSkillPoints
        case fight
        case myFights
        case getFight(id: Int)
        case leaderboard
        
        var path: String {
            switch self {
            case .login:
                return "/login.php"
            case .register:
                return "/register.php"
            case .logout:
                return "/logout.php"
            case .getMyBarbarian:
                return "/get_my_barbarian.php"
            case .getBarbarian(let id):
                return "/get_barbarian.php?id=\(id)"
            case .createBarbarian:
                return "/create_or_reset_barbarian.php"
            case .avatars:
                return "/avatars.php"
            case .spendSkillPoints:
                return "/spend_skill_points.php"
            case .fight:
                return "/fight.php"
            case .myFights:
                return "/my_fights.php"
            case .getFight(let id):
                return "/get_fight.php?id=\(id)"
            case .leaderboard:
                return "/leaderboard.php"
            }
        }
        
        var url: URL? {
            return URL(string: APIConfig.baseURL + path)
        }
    }
}
