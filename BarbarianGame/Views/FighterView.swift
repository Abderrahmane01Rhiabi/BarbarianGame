//
//  FighterView.swift
//  BarbarianGame
//
//  Created by tplocal on 16/12/2025.
//

import SwiftUI

//Affichage de la barre de vie selon le joueur
struct FighterView: View {

    let name: String
    let hp: Int
    let maxHp: Int
    let isEnemy: Bool

    private var hpPercentage: CGFloat {
        CGFloat(hp) / CGFloat(maxHp)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {

            Text(name)
                .font(.headline)

            HStack {
                Text("PV")
                Spacer()
                Text("\(hp) / \(maxHp)")
                    .foregroundColor(.red)
            }

            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                    Rectangle()
                        .fill(isEnemy ? Color.purple : Color.red)
                        .frame(width: geo.size.width * hpPercentage) //Pour réduire la barre selon les hp
                        .animation(.easeInOut(duration: 0.5), value: hp)
                }
                .cornerRadius(10)
            }
            .frame(height: 20)
        }
        .padding()
        .background(Color.gray.opacity(0.05))
        .cornerRadius(12)
    }
}




