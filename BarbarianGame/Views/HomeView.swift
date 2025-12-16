//
//  HomeView.swift
//  BarbarianGame
//
//  Created by tplocal on 09/12/2025.
//

import SwiftUI

struct HomeView: View {
    
    @State private var barbarian: Barbarian?
    @State private var isLoading: Bool = true
    @State private var errorMessage: String?
    @State private var showingLogoutAlert = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                
                Spacer()
                
                if isLoading {
                    // chargement
                    ProgressView("chargement...")
                    
                } else if let errorMessage = errorMessage {
                    // erreur
                    VStack(spacing: 10) {
                        Text("erreur")
                            .font(.headline)
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .font(.caption)
                            .multilineTextAlignment(.center)
                        
                        Button("réessayer") {
                            Task {
                                await loadBarbarian()
                            }
                        }
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                    
                } else if let barbarian = barbarian {
                    // a un barbare
                    VStack(spacing: 15) {
                        Text("bienvenue")
                            .font(.title2)
                            .foregroundColor(.gray)
                        
                        Text(barbarian.name)
                            .font(.largeTitle)
                            .bold()
                        
                        HStack(spacing: 20) {
                            VStack {
                                Text("niveau")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                Text("\(barbarian.love)")
                                    .font(.title)
                                    .bold()
                            }
                            
                            VStack {
                                Text("exp")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                Text("\(barbarian.exp)")
                                    .font(.title)
                                    .bold()
                            }
                        }
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)
                        
                        NavigationLink(destination: BarbarianDetailView(barbarian: barbarian)) {
                            Text("voir mon barbare")
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .padding(.horizontal)
                    }
                    
                } else {
                    // pas de barbare
                    VStack(spacing: 15) {
                        Text("barbarian game")
                            .font(.largeTitle)
                            .bold()
                        
                        Text("tu n'as pas encore de barbare")
                            .font(.title3)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                        
                        Image(systemName: "figure.martial.arts")
                            .font(.system(size: 80))
                            .foregroundColor(.orange)
                            .padding()
                        
                        NavigationLink(destination: CreateBarbarianView()) {
                            Text("creer mon barbare")
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.green)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .padding(.horizontal)
                    }
                }
                
                Spacer()
                
                // bouton logout
                Button(action: {
                    showingLogoutAlert = true
                }) {
                    Text("deconnexion")
                        .foregroundColor(.red)
                }
                .alert("déconnexion", isPresented: $showingLogoutAlert) {
                    Button("annuler", role: .cancel) { }
                    Button("déconnexion", role: .destructive) {
                        logout()
                    }
                } message: {
                    Text("voulez-vous vraiment vous déconnecter ?")
                }
                
            }
            Spacer()
            .task {
                await loadBarbarian()
            }
        }
    }
    
    func loadBarbarian() async {
        isLoading = true
        errorMessage = nil
        
        do {
            barbarian = try await BarbarianService.shared.getMyBarbarian()
            isLoading = false
        } catch {
            isLoading = false
            errorMessage = error.localizedDescription
            print("erreur chargement barbare: \(error)")
        }
    }
    
    func logout() {
        Task {
            await AuthManager.shared.logout()
        }
    }
}

#Preview {
    HomeView()
}
