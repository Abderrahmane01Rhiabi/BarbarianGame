//
//  FightReplayView.swift
//  BarbarianGame
//
//  Created by tplocal on 16/12/2025.
//

import SwiftUI

struct FightReplayView: View {

    @StateObject private var vm: FightReplayViewModel

    init(fight: FightHistory,
         myBarbarian: Barbarian,
         opponent: Barbarian) {

        _vm = StateObject(wrappedValue: FightReplayViewModel(
            fight: fight,
            myBarbarian: myBarbarian,
            opponent: opponent
        ))
    }

    var body: some View {
        VStack(spacing: 20) {


            Divider()

            // Logs progressifs
            ScrollViewReader { proxy in //Permet de scroll automatiquement
                ScrollView {
                    VStack(alignment: .leading, spacing: 8) {
                        ForEach(vm.displayedRounds) { round in
                            Text(round.description(
                                myBarbarian: vm.myBarbarian,
                                opponent: vm.opponent
                            ))
                            .padding(8)
                            .background(
                                round.actor == vm.myBarbarian.id
                                    ? Color.green.opacity(0.1)
                                    : Color.red.opacity(0.1)
                            )
                            .cornerRadius(6)
                            .id(round.id) 
                        }
                    }
                    .padding(.horizontal)
                }
                .frame(maxHeight: 250)
                .onChange(of: vm.displayedRounds.count) {
                    if let last = vm.displayedRounds.last {
                        withAnimation(.easeOut) {
                            proxy.scrollTo(last.id, anchor: .bottom)
                        }
                    }
                }

            }
        }
        .padding()
        .task {
            await vm.startReplay()
        }
    }
}

