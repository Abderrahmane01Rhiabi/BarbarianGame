//
//  CombatView.swift
//  BarbarianGame
//
//  Created by tplocal on 13/12/2025.
//
import Foundation
import SwiftUI

struct CombatView: View {

    @StateObject private var viewModel = FightViewModel()
    let myBarbarian: Barbarian

    var body: some View {
        VStack(spacing: 20) {

            //Loader
            if viewModel.isLoading {
                ProgressView("Combat en cours…")
                    .progressViewStyle(CircularProgressViewStyle())
            }

            //Message d'erreur
            if let error = viewModel.errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
            }

            //Résultat du combat
            if let fight = viewModel.fightResult {
                AnimatedFightView(
                    fight: fight,
                    myBarbarian: myBarbarian
                )
            }
            


            Spacer()
            
            Button(action: {
                Task { await viewModel.startFight() }
            }) {
                Text("Combattre")
                    .bold()
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(viewModel.isLoading ? Color.gray : Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .disabled(viewModel.isLoading)
            .padding(.horizontal)
        }
        .padding()
    }
}

