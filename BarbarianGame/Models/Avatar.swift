//
//  Avatar.swift
//  BarbarianGame
//
//  Created by tplocal on 07/12/2025.
//

import Foundation

struct Avatar: Codable, Identifiable {
    let id: Int
    let imagePath: String
    
    // mappage json
    enum CodingKeys: String, CodingKey {
        case id
        case imagePath = "image_path"
    }
}

// extension pour ajouter des proprietes utiles
extension Avatar {
    
    // construire l'url complete de l'avatar
    var imageURL: URL? {
        let baseURL = "https://vps.vautard.fr"
        let fullPath = "\(baseURL)/\(imagePath)"
        return URL(string: fullPath)
    }
}
    
