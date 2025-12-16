//
//  FightViewModel.swift
//  BarbarianGame
//
//  Created by tplocal on 16/12/2025.
//

import SwiftUI

@MainActor
class FightViewModel: ObservableObject {

    @Published var fightResult: Fight?
    @Published var errorMessage: String?
    @Published var isLoading = false

    

    func startFight() async {
        isLoading = true
        errorMessage = nil

        do {
            fightResult = try await CombatService.shared.fight()
        } catch NetworkError.waitdelay {
            errorMessage = "Tu dois attendre avant de lancer un nouveau combat."
        } catch NetworkError.unauthorized {
            errorMessage = "Session expirée."
        } catch {
            errorMessage = "Erreur réseau."
        }
        isLoading = false
    }
    
}
