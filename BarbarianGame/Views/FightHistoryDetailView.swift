//
//  FightHistoryDetailView.swift
//  BarbarianGame
//
//  Created by tplocal on 16/12/2025.
//

import SwiftUI
// vue de detail d'un combat historique
struct FightHistoryDetailView: View {
    let fight: FightHistory
    let myBarbarian: Barbarian
    let opponent: Barbarian?
    
    @State private var myAvatar: Avatar?
    @State private var opponentAvatar: Avatar?
    
    var body: some View {
        ScrollView {
            VStack(spacing: 15) {
                // titre victoire/defaite
                Text(fight.didIWin(myBarbarianId: myBarbarian.id) ? "🎉 Victoire !" : "💀 Défaite")
                    .font(.title)
                    .bold()
                
                // afficher les deux combattants
                HStack(spacing: 40) {
                    // mon barbare
                    VStack {
                        if let avatar = myAvatar {
                            AsyncImage(url: avatar.imageURL) { image in
                                image
                                    .resizable()
                                    .scaledToFit()
                            } placeholder: {
                                ProgressView()
                            }
                            .frame(width: 60, height: 60)
                            .cornerRadius(8)
                        } else {
                            Color.gray.opacity(0.3)
                                .frame(width: 60, height: 60)
                                .cornerRadius(8)
                        }
                        
                        Text(myBarbarian.name)
                            .font(.caption)
                            .bold()
                            .foregroundColor(.green)
                    }
                    
                    Text("VS")
                        .font(.headline)
                        .foregroundColor(.orange)
                    
                    // adversaire
                    VStack {
                        if let avatar = opponentAvatar {
                            AsyncImage(url: avatar.imageURL) { image in
                                image
                                    .resizable()
                                    .scaledToFit()
                            } placeholder: {
                                ProgressView()
                            }
                            .frame(width: 60, height: 60)
                            .cornerRadius(8)
                        } else {
                            Color.gray.opacity(0.3)
                                .frame(width: 60, height: 60)
                                .cornerRadius(8)
                        }
                        
                        if let opponent = opponent {
                            Text(opponent.name)
                                .font(.caption)
                                .bold()
                                .foregroundColor(.red)
                        } else {
                            Text("adversaire")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
                
                // XP gagnee
                Text("XP gagnée : +\(fight.expGained(myBarbarianId: myBarbarian.id))")
                    .font(.headline)
                    .foregroundColor(.blue)
                
                // liste des rounds
                if let opponent = opponent {
                    FightReplayView(
                        fight: fight,
                        myBarbarian: myBarbarian,
                        opponent: opponent
                    )
                }
            }
            .padding()
        }
        .navigationTitle("details combat")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await loadAvatars()
        }
    }
    
    func loadAvatars() async {
        do {
            let avatars = try await BarbarianService.shared.getAvatars()
            myAvatar = avatars.first { $0.id == myBarbarian.avatarId }
            if let opponent = opponent {
                opponentAvatar = avatars.first { $0.id == opponent.avatarId }
            }
        } catch {
            print("erreur chargement avatars: \(error)")
        }
    }
}
