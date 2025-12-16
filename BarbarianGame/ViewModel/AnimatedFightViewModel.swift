//
//  AnimatedFightViewModel.swift
//  BarbarianGame
//
//  Created by tplocal on 16/12/2025.
//

import SwiftUI

@MainActor
class AnimatedFightViewModel: ObservableObject {

    let fight: Fight
    let myBarbarian: Barbarian

    @Published var currentRoundIndex = -1
    @Published var displayedRounds: [FightRound] = []

    @Published var myHp: Int
    @Published var opponentHp: Int

    @Published var isFinished = false
    

    

    init(fight: Fight, myBarbarian: Barbarian) {
        self.fight = fight
        self.myBarbarian = myBarbarian
        self.myHp = myBarbarian.hp
        self.opponentHp = fight.opponent.hp
    }

    func start()  async -> Bool {
        guard let rounds = fight.log.rounds else { return false } //Si on a pas de round on return false

        for (index, round) in rounds.enumerated() {
            try? await Task.sleep(nanoseconds: 2_000_000_000) //On attend 2 secondes à chaque tour de boucle

            withAnimation(.easeInOut) {
                currentRoundIndex = index
                displayedRounds.append(round)
                applyDamage(round)
            }
        }

        isFinished = true
        return isFinished
    }

    private func applyDamage(_ round: FightRound) {
        if round.actor == myBarbarian.id {
            opponentHp = round.hpTargetAfter
        } else {
            myHp = round.hpTargetAfter
        }
    }

}



