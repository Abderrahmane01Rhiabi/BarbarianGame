import SwiftUI
struct PointsView: View {
    @StateObject private var vm: PointsViewModel

    init(barbarian : Barbarian,maxPoints: Int) {
        _vm = StateObject(wrappedValue: PointsViewModel(maxPoints: maxPoints,barbarian: barbarian))
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 15) {

            Text("Points à dépenser : \(vm.points)")
                .font(.title)
                .padding(.horizontal)

            Text("Statistiques")
                .font(.headline)
                .padding(.horizontal)

            statRow(icon: "⚔️", name: "attaque  \(vm.barbarian.attack) +", value: $vm.attack, addAction: vm.addAttack,subAction: vm.subAttack)
            statRow(icon: "🛡️", name: "defense  \(vm.barbarian.defense) +", value: $vm.defense, addAction: vm.addDefense,subAction: vm.subDefense)
            statRow(icon: "🎯", name: "precision  \(vm.barbarian.precision) +", value: $vm.precision, addAction: vm.addPrecision,subAction: vm.subPrecision)
            statRow(icon: "💨", name: "evasion  \(vm.barbarian.evasion) +", value: $vm.evasion, addAction: vm.addEvasion,subAction: vm.subEvasion)

            Button {
                Task {
                    do {
                        try await vm.depenserPoint()
                        if vm.isLoading == false{
                            vm.attack = 0
                            vm.defense = 0
                            vm.precision = 0
                            vm.evasion = 0
                            await vm.refreshBarbarian() //Pour modifier les stats sur la page
                        }
                    } catch {
                        vm.errorMessage = "Erreur lors de la dépense des points : \(error)"
                    }
                }
            } label: {
                Text(vm.isLoading ? "En cours..." : "Dépenser les points")
                    .bold()
                    .frame(maxWidth: .infinity)
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .disabled(!vm.hasSpentPoints || vm.isLoading)
            .padding(.horizontal)

        }
        .padding()
        .background(Color.gray.opacity(0.05))
        .cornerRadius(10)
        
    }
    
    struct StatRow: View { //On redéfinit StatRow pour pouvoir Binder les valeurs
        let icon: String
        let name: String
        @Binding var value: Int

        var body: some View {
            HStack {
                Text(icon).font(.title2)
                Text(name).foregroundColor(.gray)
                Spacer()
                Text("\(value)").font(.headline).bold()
            }
            .padding(.horizontal)
        }
    }
    private func statRow(icon: String, name: String, value: Binding<Int>, addAction: @escaping () -> Void,subAction: @escaping () -> Void) -> some View {
        HStack {
            StatRow(icon: icon, name: name, value: value)
            Button("+", action: addAction)
                .bold()
                .padding()
                .cornerRadius(5)
            Button("-", action: subAction)
                .bold()
                .padding()
                .cornerRadius(5)
        }
        .padding(.horizontal)
    }
}



