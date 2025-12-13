//
//  FightHistoryView.swift
//  BarbarianGame
//
//  Created by tplocal on 13/12/2025.
//

import SwiftUI

struct FightHistoryView: View {
    let myBarbarian: Barbarian
    
    @State private var fights: [FightHistory] = []
    @State private var isLoading = false
    @State private var errorMessage: String?
    
    var body: some View {
        VStack {
            if isLoading {
                ProgressView("chargement historique...")
                    .padding()
            } else if let errorMessage = errorMessage {
                VStack(spacing: 10) {
                    Text("erreur")
                        .font(.headline)
                        .foregroundColor(.red)
                    Text(errorMessage)
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    Button("reessayer") {
                        Task {
                            await loadFights()
                        }
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
            } else if fights.isEmpty {
                VStack(spacing: 15) {
                    Image(systemName: "list.bullet")
                        .font(.system(size: 60))
                        .foregroundColor(.gray)
                    
                    Text("aucun combat")
                        .font(.title2)
                        .foregroundColor(.gray)
                    
                    Text("lance ton premier combat pour voir l'historique")
                        .font(.caption)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                }
                .padding()
            } else {
                List {
                    ForEach(fights) { fight in
                        FightHistoryRow(
                            fight: fight,
                            myBarbarian: myBarbarian
                        )
                    }
                }
                .listStyle(.plain)
            }
        }
        .navigationTitle("historique")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await loadFights()
        }
    }
    
    func loadFights() async {
        isLoading = true
        errorMessage = nil
        
        do {
            fights = try await CombatService.shared.getMyFights()
            isLoading = false
        } catch {
            isLoading = false
            errorMessage = error.localizedDescription
            print("erreur chargement historique: \(error)")
        }
    }
}

// ligne d'historique pour un combat
struct FightHistoryRow: View {
    let fight: FightHistory
    let myBarbarian: Barbarian
    
    @State private var opponent: Barbarian?
    @State private var opponentAvatar: Avatar?
    
    var body: some View {
        NavigationLink(destination: FightHistoryDetailView(
            fight: fight,
            myBarbarian: myBarbarian,
            opponent: opponent
        )) {
            HStack(spacing: 15) {
                // avatar adversaire
                if let avatar = opponentAvatar {
                    AsyncImage(url: avatar.imageURL) { image in
                        image
                            .resizable()
                            .scaledToFit()
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: 50, height: 50)
                    .cornerRadius(8)
                } else {
                    Color.gray.opacity(0.3)
                        .frame(width: 50, height: 50)
                        .cornerRadius(8)
                }
                
                // infos combat (nom adversaire, victoire/defaite, xp)
                VStack(alignment: .leading, spacing: 5) {
                    HStack {
                        if let opponent = opponent {
                            Text(opponent.name)
                                .font(.headline)
                        } else {
                            Text("adversaire #\(fight.opponentId(myBarbarianId: myBarbarian.id))")
                                .font(.headline)
                                .foregroundColor(.gray)
                        }
                        
                        Spacer()
                        
                        // icone victoire/defaite
                        if fight.didIWin(myBarbarianId: myBarbarian.id) {
                            Text("V")
                                .font(.title2)
                        } else {
                            Text("L")
                                .font(.title2)
                        }
                    }
                    
                    HStack {
                        Text(fight.didIWin(myBarbarianId: myBarbarian.id) ? "victoire" : "defaite")
                            .font(.caption)
                            .foregroundColor(fight.didIWin(myBarbarianId: myBarbarian.id) ? .green : .red)
                        
                        Text("•")
                            .foregroundColor(.gray)
                        
                        //au lieu de faire "Text("+\(fight.attackerId == myBarbarian.id ? fight.expAttacker : fight.expDefender) xp")"
                        Text("+\(fight.expGained(myBarbarianId: myBarbarian.id)) xp")
                            .font(.caption)
                            .foregroundColor(.blue)
                    }
                }
            }
            .padding(.vertical, 5)
        }
        .task {
            await loadOpponent()
        }
    }
    
    func loadOpponent() async {
        let opponentId = fight.opponentId(myBarbarianId: myBarbarian.id)
        
        do {
            // charger l'adversaire
            opponent = try await BarbarianService.shared.getBarbarian(id: opponentId)
            
            // charger son avatar
            if let avatarId = opponent?.avatarId {
                let avatars = try await BarbarianService.shared.getAvatars()
                opponentAvatar = avatars.first { $0.id == avatarId }
            }
        } catch {
            print("erreur chargement adversaire: \(error)")
        }
    }
}

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
                if let rounds = fight.log.rounds, let opponent = opponent {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 5) {
                            ForEach(rounds) { round in
                                Text(round.description(myBarbarian: myBarbarian, opponent: opponent))
                                    .padding(8)
                                    .background(
                                        round.actor == myBarbarian.id
                                            ? Color.green.opacity(0.1)
                                            : Color.red.opacity(0.1)
                                    )
                                    .cornerRadius(5)
                            }
                        }
                    }
                    .frame(maxHeight: 300)
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

#Preview {
    NavigationStack {
        FightHistoryView(myBarbarian: Barbarian(
            id: 1,
            name: "YAYA",
            avatarId: 21,
            love: 1,
            exp: 0,
            skillPoints: 0,
            attack: 1,
            defense: 1,
            precision: 1,
            evasion: 1,
            maxHp: 100,
            createdAt: "aujourd'hui",
            lastFightAt: nil
        ))
    }
}
