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
                FightSummaryView(fight: fight, myBarbarian: myBarbarian)
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

struct FightSummaryView: View {
    let fight: Fight
    let myBarbarian: Barbarian
    @State private var opponentAvatar: Avatar?
    @State private var myAvatar: Avatar?
    
    
    var body: some View {
        VStack(spacing: 10) {
            Text(fight.didIWin(myBarbarianId: myBarbarian.id) ? "🎉 Victoire !" : "💀 Défaite")
                .font(.title)
                .bold()

            // afficher les deux combattants
            HStack(spacing: 40) {
                // Mon barbare
                VStack {
                    if let avatar = myAvatar {
                        AsyncImage(url: avatar.imageURL) { image in
                            image.resizable().scaledToFit()
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 60, height: 60)
                    }
                    Text(myBarbarian.name)
                        .font(.caption)
                }
                
                Text("VS")
                    .font(.headline)
                
                // adversaire
                VStack {
                    if let avatar = opponentAvatar {
                        AsyncImage(url: avatar.imageURL) { image in
                            image.resizable().scaledToFit()
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 60, height: 60)
                    }
                    Text(fight.opponent.name)
                        .font(.caption)
                }
            }
            
            
            Text("XP gagnée : \(fight.expGained)")

            // Liste des rounds
            if let rounds = fight.log.rounds {
                ScrollView {
                    VStack(alignment: .leading, spacing: 5) {
                        ForEach(rounds) { round in
                            Text(round.description(myBarbarian : myBarbarian,opponent : fight.opponent))
                                .padding(5)
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(5)
                        }
                    }
                }
                .frame(maxHeight: 300)
            }
        }
        .padding()
        .background(Color.yellow.opacity(0.1))
        .cornerRadius(15)
        .task {
            await loadAvatars()
        }
    }
    func loadAvatars() async {
        do {
            let avatars = try await BarbarianService.shared.getAvatars()
            myAvatar = avatars.first { $0.id == myBarbarian.avatarId }
            opponentAvatar = avatars.first { $0.id == fight.opponent.avatarId }
        } catch {
            print("erreur chargement avatars: \(error)")
        }
    }
}


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
