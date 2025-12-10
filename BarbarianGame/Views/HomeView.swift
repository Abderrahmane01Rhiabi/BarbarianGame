//
//  HomeView.swift
//  BarbarianGame
//
//  Created by tplocal on 09/12/2025.
//

import SwiftUI

struct HomeView: View {
    
    @State private var showingLogoutAlert = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                
                Text("Bienvenue dans Barbarian Game")
                    .font(.title)
                    .bold()
                    .padding()
                
                Text("Ton barbare t'attend...")
                    .foregroundColor(.gray)
                
                Spacer()
                
                // bouton logout
                Button(action: {
                    showingLogoutAlert = true
                }) {
                    Text("Deconnexion")
                        .foregroundColor(.red)
                }
                .alert("Deconnexion", isPresented: $showingLogoutAlert) {
                    Button("Annuler", role: .cancel) { }
                    Button("Deconnexion", role: .destructive) {
                        logout()
                    }
                } message: {
                    Text("voulez-vous vraiment vous deconnecter ?")
                }
                
            }
            .navigationTitle("Accueil")
        }
    }
    
    func logout() {
        Task {
            do {
                try await AuthService.shared.logout()
                // retour au login
                // on verra ca plus tard
            } catch {
                print("erreur logout: \(error)")
            }
        }
    }
}

#Preview {
    HomeView()
}
