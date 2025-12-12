//
//  BarbarianDetailView.swift
//  BarbarianGame
//
//  Created by tplocal on 12/12/2025.
//

import SwiftUI

struct BarbarianDetailView: View {
    
    let barbarian: Barbarian
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                
                // avatar
                if let avatarId = barbarian.avatarId {
                    AsyncImage(url: URL(string: "https://vps.vautard.fr/barbarians/avatars/a\(avatarId).png")) { image in
                        image
                            .resizable()
                            .scaledToFit()
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: 150, height: 150)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(15)
                }
                
                // nom
                Text(barbarian.name)
                    .font(.largeTitle)
                    .bold()
                
                // niveau et exp
                HStack(spacing: 30) {
                    VStack {
                        Text("niveau")
                            .font(.caption)
                            .foregroundColor(.gray)
                        Text("\(barbarian.love)")
                            .font(.title)
                            .bold()
                            .foregroundColor(.orange)
                    }
                    
                    VStack {
                        Text("experience")
                            .font(.caption)
                            .foregroundColor(.gray)
                        Text("\(barbarian.exp)")
                            .font(.title)
                            .bold()
                            .foregroundColor(.blue)
                    }
                    
                    VStack {
                        Text("points")
                            .font(.caption)
                            .foregroundColor(.gray)
                        Text("\(barbarian.skillPoints)")
                            .font(.title)
                            .bold()
                            .foregroundColor(.green)
                    }
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
                
                // statistiques de combat
                VStack(alignment: .leading, spacing: 15) {
                    Text("statistiques")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    StatRow(icon: "⚔️", name: "attaque", value: barbarian.attack)
                    StatRow(icon: "🛡️", name: "defense", value: barbarian.defense)
                    StatRow(icon: "🎯", name: "precision", value: barbarian.precision)
                    StatRow(icon: "💨", name: "evasion", value: barbarian.evasion)
                }
                .padding()
                .background(Color.gray.opacity(0.05))
                .cornerRadius(10)
                
                // points de vie
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text("points de vie")
                            .font(.headline)
                        Spacer()
                        Text("\(barbarian.hp) / \(barbarian.maxHp)")
                            .font(.headline)
                            .foregroundColor(.red)
                    }
                    
                    // barre de vie
                    GeometryReader { geometry in
                        ZStack(alignment: .leading) {
                            Rectangle()
                                .fill(Color.gray.opacity(0.2))
                                .frame(height: 20)
                                .cornerRadius(10)
                            
                            Rectangle()
                                .fill(Color.red)
                                .frame(width: geometry.size.width * hpPercentage, height: 20)
                                .cornerRadius(10)
                        }
                    }
                    .frame(height: 20)
                }
                .padding()
                .background(Color.gray.opacity(0.05))
                .cornerRadius(10)
                
                // boutons d'action
                VStack(spacing: 15) {
                    
                    if barbarian.skillPoints > 0 {
                        NavigationLink(destination: Text("depenser points")) {
                            HStack {
                                Image(systemName: "star.fill")
                                Text("depenser \(barbarian.skillPoints) points")
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                        }
                    }
                    
                    NavigationLink(destination: Text("combattre")) {
                        HStack {
                            Image(systemName: "figure.martial.arts")
                            Text("lancer un combat")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.orange)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                    
                    NavigationLink(destination: Text("historique")) {
                        HStack {
                            Image(systemName: "list.bullet")
                            Text("historique des combats")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                }
                
            }
            .padding()
        }
        .navigationTitle("mon barbare")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    var hpPercentage: Double {
        return Double(barbarian.hp) / Double(barbarian.maxHp)
    }
}

// composant pour afficher une stat
struct StatRow: View {
    let icon: String
    let name: String
    let value: Int
    
    var body: some View {
        HStack {
            Text(icon)
                .font(.title2)
            
            Text(name)
                .foregroundColor(.gray)
            
            Spacer()
            
            Text("\(value)")
                .font(.headline)
                .bold()
        }
        .padding(.horizontal)
    }
}

#Preview {
    NavigationStack {
        BarbarianDetailView(barbarian: Barbarian(
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
            maxHp: 100
        ))
    }
}
