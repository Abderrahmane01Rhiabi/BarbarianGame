//
//  PointViewModel.swift
//  BarbarianGame
//
//  Created by tplocal on 16/12/2025.
//
import SwiftUI

@MainActor
class PointsViewModel: ObservableObject {
    var maxPoints : Int
    @Published var barbarian : Barbarian
    @Published var points: Int
    @Published var attack: Int = 0
    @Published var defense: Int = 0
    @Published var precision: Int = 0
    @Published var evasion: Int = 0
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    init(maxPoints: Int,barbarian : Barbarian) {
        self.maxPoints = maxPoints
        self.points = maxPoints
        self.barbarian = barbarian
    }

    func addAttack() {
        guard points > 0 else { return }
        attack += 1
        points -= 1
    }

    func addDefense() {
        guard points > 0 else { return }
        defense += 1
        points -= 1
    }

    func addPrecision() {
        guard points > 0 else { return }
        precision += 1
        points -= 1
    }

    func addEvasion() {
        guard points > 0 else { return }
        evasion += 1
        points -= 1
    }
    
    func subAttack() {
        guard attack > 0 && points < maxPoints else { return }
        attack -= 1
        points += 1
    }


    func subDefense() {
        guard defense > 0 && points < maxPoints else { return }
        defense -= 1
        points += 1
    }

    func subPrecision() {
        guard precision > 0 && points < maxPoints else { return }
        precision -= 1
        points += 1
    }

    func subEvasion() {
        guard evasion > 0 && points < maxPoints else { return }
        evasion -= 1
        points += 1
    }


    var hasSpentPoints: Bool {
        attack > 0 || defense > 0 || precision > 0 || evasion > 0
    }

    func depenserPoint() async throws{
        isLoading = true
        errorMessage = nil

        do {
            try await BarbarianService.shared.spendSkillPoints(
                attack: attack,
                defense: defense,
                precision: precision,
                evasion: evasion)
        } catch NetworkError.pointinsuffisant {
            errorMessage = "Vous n'avez pas assez de points"
        } catch NetworkError.unauthorized {
            errorMessage = "Session expirée."
        } catch {
            errorMessage = "Erreur réseau."
        }
        isLoading = false
    }
    func refreshBarbarian() async {
            do {
                if let updatedBarbarian = try await BarbarianService.shared.getMyBarbarian() {
                    barbarian = updatedBarbarian
                }
            } catch {
                print("erreur rafraichissement barbare: \(error)")
            }
        }
    
}
