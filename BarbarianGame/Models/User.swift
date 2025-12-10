//
//  User.swift
//  BarbarianGame
//
//  Created by tplocal on 07/12/2025.
//

import Foundation

// identifiants pour login et register
struct UserCredentials: Codable {
    let username: String
    let password: String
}

// reponse de l'api apres connexion
struct AuthResponse: Codable {
    let token: String
}
