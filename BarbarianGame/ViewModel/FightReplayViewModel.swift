//
//  FightReplayViewModel.swift
//  BarbarianGame
//
//  Created by tplocal on 16/12/2025.
//

import SwiftUI

@MainActor
class FightReplayViewModel: ObservableObject {

    let fight: FightHistory
    let myBarbarian: Barbarian
    let opponent: Barbarian

    @Published var displayedRounds: [FightRound] = []
    @Published var isFinished = false

    init(fight: FightHistory,
         myBarbarian: Barbarian,
         opponent: Barbarian) {

        self.fight = fight
        self.myBarbarian = myBarbarian
        self.opponent = opponent
    }

    func startReplay() async {
        guard let rounds = fight.log.rounds else { return } //Si on a pas de round on return false

        for round in rounds {
            try? await Task.sleep(nanoseconds: 2_000_000_000)  //On attend 2 secondes à chaque tour de boucle

            withAnimation(.easeInOut) {
                displayedRounds.append(round)
            }
        }

        isFinished = true
    }

}

