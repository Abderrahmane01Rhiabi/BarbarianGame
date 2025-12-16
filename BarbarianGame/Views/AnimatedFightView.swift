//
//  AnimatedFightView.swift
//  BarbarianGame
//
//  Created by tplocal on 16/12/2025.
//
import SwiftUI

struct AnimatedFightView: View {

    let fight: Fight
    let myBarbarian: Barbarian
    @State var isFinished : Bool = false

    @StateObject private var vm: AnimatedFightViewModel

    @State private var myAvatar: Avatar?
    @State private var opponentAvatar: Avatar?
    

    init(fight: Fight, myBarbarian: Barbarian) {
        self.fight = fight
        self.myBarbarian = myBarbarian
        _vm = StateObject(wrappedValue: AnimatedFightViewModel(
            fight: fight,
            myBarbarian: myBarbarian
        ))
    }

    var body: some View {
        VStack(spacing: 20) {
            if isFinished {
                Text(vm.fight.didIWin(myBarbarianId: vm.myBarbarian.id)
                     ? "🎉 Victoire"
                     : "💀 Défaite")
                .font(.title)
                .bold()
                .padding(.top)
                Text("XP gagnée : +\(vm.fight.expGained)")
                    .font(.headline)
                    .foregroundColor(.blue)
            }
            if let avatar = opponentAvatar {
                   AsyncImage(url: avatar.imageURL) { image in
                       image
                           .resizable()
                           .scaledToFit()
                   } placeholder: {
                       ProgressView()
                   }
                   .frame(width: 70, height: 70)
                   .cornerRadius(10)
               }

               FighterView(
                   name: vm.fight.opponent.name,
                   hp: vm.opponentHp,
                   maxHp: vm.fight.opponent.maxHp,
                   isEnemy: true //pour la couleur de la barre de vie
               )

            Divider()

            // Logs
            ScrollViewReader { proxy in //Permet de scroll automatiquement
                ScrollView {
                    VStack(alignment: .leading, spacing: 8) {
                        ForEach(vm.displayedRounds) { round in
                            Text(round.description(
                                myBarbarian: vm.myBarbarian,
                                opponent: vm.fight.opponent
                            ))
                            .padding(8)
                            .background(
                                round.actor == vm.myBarbarian.id
                                    ? Color.green.opacity(0.1)
                                    : Color.red.opacity(0.1)
                            )
                            .cornerRadius(6)
                            .id(round.id)
                        }
                    }
                    .padding(.horizontal)
                }
                .frame(maxHeight: 250)
                .onChange(of: vm.displayedRounds.count) {
                    if let last = vm.displayedRounds.last {
                        withAnimation(.easeOut) {
                            proxy.scrollTo(last.id, anchor: .bottom)
                        }
                    }
                }

            }


            Divider()

            FighterView(
                    name: vm.myBarbarian.name,
                    hp: vm.myHp,
                    maxHp: vm.myBarbarian.maxHp,
                    isEnemy: false //pour la couleur de la barre de vie
                )

                if let avatar = myAvatar {
                    AsyncImage(url: avatar.imageURL) { image in
                        image
                            .resizable()
                            .scaledToFit()
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: 70, height: 70)
                    .cornerRadius(10)
                }
            
        }
        .padding()
        .task {
            await loadAvatars()
            await isFinished = vm.start() //Pour l'affichage de la victoire
        }
    }
    
    func loadAvatars() async {
        do {
            let avatars = try await BarbarianService.shared.getAvatars()
            myAvatar = avatars.first { $0.id == myBarbarian.avatarId }
            opponentAvatar = avatars.first { $0.id == fight.opponent.avatarId }
        } catch {
            print("erreur chargement avatars combat: \(error)")
        }
    }

}


