//
//  CreateBarbarianView.swift
//  BarbarianGame
//
//  Created by tplocal on 12/12/2025.
//

import SwiftUI

struct CreateBarbarianView: View {
    
    @Environment(\.dismiss) var dismiss
    
    // parametre pour savoir si c'est une recreation
    let isRecreating: Bool
    
    @State private var name: String = ""
    @State private var avatars: [Avatar] = []
    @State private var selectedAvatarId: Int?
    
    @State private var isLoadingAvatars: Bool = true
    @State private var isCreating: Bool = false
    @State private var errorMessage: String?
    
    // initializer avec valeur par defaut
    init(isRecreating: Bool = false) {
        self.isRecreating = isRecreating
    }
    
    var body: some View {
        VStack(spacing: 20) {
            
            Text(isRecreating ? "recreer ton barbare" : "creer ton barbare")
                .font(.largeTitle)
                .bold()

            if isRecreating {
                Text("ton ancien barbare sera supprime")
                    .font(.caption)
                    .foregroundColor(.red)
            }
            
            // champ nom
            VStack(alignment: .leading, spacing: 5) {
                Text("nom du barbare")
                    .font(.headline)
                
                TextField("entre un nom", text: $name)
                    .textFieldStyle(.roundedBorder)
                    .disabled(isCreating)
            }
            .padding(.horizontal)
            
            // liste des avatars
            VStack(alignment: .leading, spacing: 5) {
                Text("choisis un avatar")
                    .font(.headline)
                    .padding(.horizontal)
                
                if isLoadingAvatars {
                    ProgressView("chargement des avatars...")
                        .padding()
                } else if avatars.isEmpty {
                    Text("aucun avatar disponible")
                        .foregroundColor(.red)
                        .padding()
                } else {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 15) {
                            ForEach(avatars) { avatar in
                                AvatarButton(
                                    avatar: avatar,
                                    isSelected: selectedAvatarId == avatar.id,
                                    action: {
                                        selectedAvatarId = avatar.id
                                    }
                                )
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
            
            // message d'erreur
            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.caption)
                    .padding()
            }
            
            Spacer()
            
            // bouton creer
            Button(action: {
                Task {
                    await createBarbarian()
                }
            }) {
                if isCreating {
                    ProgressView()
                        .tint(.white)
                } else {
                    Text(isRecreating ? "recreer mon barbare" : "creer mon barbare")
                        .bold()
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(canCreate ? (isRecreating ? Color.red : Color.green) : Color.gray)            .foregroundColor(.white)
            .cornerRadius(10)
            .disabled(!canCreate || isCreating)
            .padding(.horizontal)
            
        }
        .navigationTitle("creation")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await loadAvatars()
        }
    }
    
    var canCreate: Bool {
        return !name.isEmpty && selectedAvatarId != nil && !isLoadingAvatars
    }
    
    func loadAvatars() async {
        isLoadingAvatars = true
        
        do {
            avatars = try await BarbarianService.shared.getAvatars()
            isLoadingAvatars = false
        } catch {
            isLoadingAvatars = false
            errorMessage = "erreur chargement avatars: \(error.localizedDescription)"
            print("erreur avatars: \(error)")
        }
    }
    
    func createBarbarian() async {
        guard let avatarId = selectedAvatarId else { return }
        
        errorMessage = nil
        isCreating = true
        
        do {
            let barbarian = try await BarbarianService.shared.createBarbarian(
                name: name,
                avatarId: avatarId
            )
            
            print("barbare \(isRecreating ? "recree" : "cree"): \(barbarian.name)")
            
            isCreating = false
            
            // retour a homeview
            dismiss()
            
        } catch {
            isCreating = false
            errorMessage = "erreur \(isRecreating ? "recreation" : "creation"): \(error.localizedDescription)"
            print("erreur \(isRecreating ? "recreation" : "creation") barbare: \(error)")
        }
    }
}

// composant pour afficher un avatar
struct AvatarButton: View {
    let avatar: Avatar
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 5) {
                AsyncImage(url: avatar.imageURL) { image in
                    image
                        .resizable()
                        .scaledToFit()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 80, height: 80)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(isSelected ? Color.green : Color.clear, lineWidth: 3)
                )
                
                Text("avatar \(avatar.id)")
                    .font(.caption)
                    .foregroundColor(isSelected ? .green : .gray)
            }
        }
    }
}

#Preview {
    NavigationStack {
        CreateBarbarianView()
    }
}
