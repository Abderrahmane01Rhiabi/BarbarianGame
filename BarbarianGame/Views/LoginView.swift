//
//  LoginView.swift
//  BarbarianGame
//
//  Created by tplocal on 09/12/2025.
//

import SwiftUI

struct LoginView: View {
    
    // variables d'etat pour les champs de saisie
    @State private var username: String = ""
    @State private var password: String = ""
    
    // variables pour gerer l'etat de l'ui
    @State private var isLoading: Bool = false
    @State private var errorMessage: String?
    @State private var isLoggedIn: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                
                // titre
                Text("Barbarian Game")
                    .font(.largeTitle)
                    .bold()
                
                Text("Connexion")
                    .font(.title2)
                    .foregroundColor(.gray)
                
                Spacer()
                
                // champ username
                TextField("Nom d'utilisateur", text: $username)
                    .textFieldStyle(.roundedBorder)
                    .autocapitalization(.none)
                    .disabled(isLoading)
                
                // champ password
                SecureField("Mot de passe", text: $password)
                    .textFieldStyle(.roundedBorder)
                    .disabled(isLoading)
                
                // message d'erreur
                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.caption)
                }
                
                // bouton connexion
                Button(action: {
                    Task {
                        await login()
                    }
                }) {
                    if isLoading {
                        ProgressView()
                            .tint(.white)
                    } else {
                        Text("Se connecter")
                            .bold()
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                .disabled(isLoading || username.isEmpty || password.isEmpty)
                
                // lien vers inscription
                NavigationLink(destination: RegisterView()) {
                    Text("Pas de compte ? S'inscrire")
                        .foregroundColor(.blue)
                }
                
                Spacer()
                
                // navigation vers la vue principale apres connexion
                NavigationLink(destination: HomeView(), isActive: $isLoggedIn) {
                    EmptyView()
                }
            }
            .padding()
        }
    }
    
    // fonction de connexion
    func login() async {
        // reset erreur
        errorMessage = nil
        isLoading = true
        
        do {
            // appeler authservice
            let response = try await AuthService.shared.login(
                username: username,
                password: password
            )
            
            print("connecte avec token: \(response.token)")
            
            // notifier le authmanager
            AuthManager.shared.login()
            
            // connexion reussie
            isLoading = false
            isLoggedIn = true
            
        } catch {
            // erreur
            isLoading = false
            
            // afficher l'erreur complete pour debug
            print("ERREUR COMPLETE LOGIN: \(error)")
            
            if let networkError = error as? NetworkError {
                switch networkError {
                case .serverError(let message):
                    errorMessage = "erreur serveur: \(message)"
                case .decodingError:
                    errorMessage = "erreur de decodage json"
                case .unauthorized:
                    errorMessage = "non autorise"
                case .invalidURL:
                    errorMessage = "url invalide"
                case .noData:
                    errorMessage = "pas de donnees"
                }
            } else {
                errorMessage = "erreur: \(error.localizedDescription)"
            }
        }
    }
}

// preview pour xcode
#Preview {
    LoginView()
}
