//
//  LeaderboardView.swift
//  BarbarianGame
//
//  Created by tplocal on 14/12/2025.
//
import SwiftUI

struct LeaderboardView: View {
    
    @State private var entries: [LeaderboardEntry] = []
    @State private var isLoading = false
    @State private var errorMessage: String?
    
    var body: some View {
        ZStack {
            if isLoading {
                ProgressView("Chargement du classement...")
            } else if let error = errorMessage {
                VStack(spacing: 20) {
                    Image(systemName: "exclamationmark.triangle")
                        .font(.system(size: 50))
                        .foregroundColor(.orange)
                    
                    Text("Erreur")
                        .font(.title2)
                        .bold()
                    
                    Text(error)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    Button("Reessayer") {
                        Task {
                            await loadLeaderboard()
                        }
                    }
                    .buttonStyle(.bordered)
                }
            } else if entries.isEmpty {
                VStack(spacing: 20) {
                    Image(systemName: "list.bullet")
                        .font(.system(size: 50))
                        .foregroundColor(.secondary)
                    
                    Text("Aucun barbare dans le classement")
                        .foregroundColor(.secondary)
                }
            } else {
                List {
                    ForEach(Array(entries.enumerated()), id: \.element.id) { index, entry in
                        LeaderboardRow(entry: entry, rank: index + 1)
                    }
                }
                .listStyle(.plain)
            }
        }
        .navigationTitle("🏆 Classement")
        .task {
            await loadLeaderboard()
        }
        .refreshable {
            await loadLeaderboard()
        }
    }
    
    func loadLeaderboard() async {
        isLoading = true
        errorMessage = nil
        
        do {
            entries = try await BarbarianService.shared.fetchLeaderboard()
            isLoading = false
        } catch {
            isLoading = false
            errorMessage = "Impossible de charger le classement"
            print("Erreur leaderboard: \(error)")
        }
    }
}

struct LeaderboardRow: View {
    let entry: LeaderboardEntry
    let rank: Int
    
    @State private var avatar: Avatar?
    
    var body: some View {
        HStack(spacing: 12) {
            // Rang
            Text("\(rank).")
                .font(.title2)
                .frame(width: 40)
                .foregroundColor(.primary)
            
            // Avatar
            if let avatar = avatar {
                AsyncImage(url: avatar.imageURL) { image in
                    image
                        .resizable()
                        .scaledToFit()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 50, height: 50)
                .clipShape(Circle())
            } else {
                ProgressView()
                    .frame(width: 50, height: 50)
            }
            
            // Informations
            VStack(alignment: .leading, spacing: 4) {
                Text(entry.name)
                    .font(.headline)
                
                HStack(spacing: 12) {
                    Label("LOVE \(entry.love)", systemImage: "heart.fill")
                        .font(.caption)
                        .foregroundColor(.red)
                    
                    Label("EXP \(entry.exp)", systemImage: "star.fill")
                        .font(.caption)
                        .foregroundColor(.orange)
                }
                
                HStack(spacing: 8) {
                    StatBadge(icon: "⚔️", value: entry.attack, color: .red)
                    StatBadge(icon: "🛡️", value: entry.defense, color: .blue)
                    StatBadge(icon: "🎯", value: entry.accuracy, color: .green)
                    StatBadge(icon: "💨", value: entry.evasion, color: .purple)
                }
            }
            
            Spacer()
        }
        .padding(.vertical, 8)
        .task {
            await loadAvatar()
        }
    }
    
    func loadAvatar() async {
        do {
            let allAvatars = try await BarbarianService.shared.getAvatars()
            avatar = allAvatars.first { $0.id == entry.avatarId }
        } catch {
            print("erreur chargement avatar pour \(entry.name): \(error)")
        }
    }
}

struct StatBadge: View {
    let icon: String
    let value: Int
    let color: Color
    
    var body: some View {
        HStack(spacing: 2) {
            Text(icon)
                .font(.caption2)
            Text("\(value)")
                .font(.caption2)
                .bold()
        }
        .padding(.horizontal, 6)
        .padding(.vertical, 2)
        .background(color.opacity(0.15))
        .cornerRadius(4)
    }
}

#Preview {
    NavigationStack {
        LeaderboardView()
    }
}
