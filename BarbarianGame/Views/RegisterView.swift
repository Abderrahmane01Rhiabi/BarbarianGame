//
//  RegisterView.swift
//  BarbarianGame
//
//  Created by tplocal on 09/12/2025.
//

import SwiftUI

struct RegisterView: View {
    
    // variables d'etat
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    
    // gestion de l'ui
    @State private var isLoading: Bool = false
    @State private var errorMessage: String?
    @State private var isRegistered: Bool = false
    
    // pour revenir en arriere
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: 20) {
            
            // titre
            Text("Barbarian Game")
                .font(.largeTitle)
                .bold()
            
            Text("Inscription")
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
            
            // champ confirmation password
            SecureField("Confirmer le mot de passe", text: $confirmPassword)
                .textFieldStyle(.roundedBorder)
                .disabled(isLoading)
            
            // message d'erreur
            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.caption)
            }
            
            // bouton inscription
            Button(action: {
                Task {
                    await register()
                }
            }) {
                if isLoading {
                    ProgressView()
                        .tint(.white)
                } else {
                    Text("S'inscrire")
                        .bold()
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.green)
            .foregroundColor(.white)
            .cornerRadius(10)
            .disabled(isLoading || !isFormValid())
            
            Spacer()
            
            // navigation apres inscription reussie
            NavigationLink(destination: HomeView(), isActive: $isRegistered) {
                EmptyView()
            }
        }
        .padding()
        .navigationTitle("Inscription")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    // validation du formulaire
    func isFormValid() -> Bool {
        return !username.isEmpty &&
               !password.isEmpty &&
               !confirmPassword.isEmpty &&
               password == confirmPassword
    }
    
    // fonction d'inscription
    func register() async {
        // reset erreur
        errorMessage = nil
        
        // verification des mots de passe
        guard password == confirmPassword else {
            errorMessage = "les mots de passe ne correspondent pas"
            return
        }
        
        guard password.count >= 4 else {
            errorMessage = "le mot de passe doit faire au moins 4 caracteres"
            return
        }
        
        isLoading = true
        
        do {
            // appeler authservice
            let response = try await AuthService.shared.register(
                username: username,
                password: password
            )
            
            print("inscription reussie, connecte automatiquement")
            
            // notifier le authmanager
            AuthManager.shared.login()
            
            // inscription reussie
            isLoading = false
            isRegistered = true
            
        } catch {
            // erreur
            isLoading = false
            
            // afficher l'erreur complete pour debug
            print("ERREUR COMPLETE: \(error)")
            
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
                case .waitdelay:
                    errorMessage = "retry plus tard"
                }
                
            } else {
                errorMessage = "erreur: \(error.localizedDescription)"
            }
        }
    }
}

// preview
#Preview {
    NavigationStack {
        RegisterView()
    }
}
