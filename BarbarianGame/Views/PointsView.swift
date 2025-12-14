import SwiftUI
struct PointsView: View {

    @StateObject private var vm: PointsViewModel

    init(maxPoints: Int) {
        _vm = StateObject(wrappedValue: PointsViewModel(maxPoints: maxPoints))
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 15) {

            Text("Points à dépenser : \(vm.points)")
                .font(.title)
                .padding(.horizontal)

            Text("Statistiques")
                .font(.headline)
                .padding(.horizontal)

            statRow(icon: "⚔️", name: "attaque", value: $vm.attack, addAction: vm.addAttack,subAction: vm.subAttack)
            statRow(icon: "🛡️", name: "defense", value: $vm.defense, addAction: vm.addDefense,subAction: vm.subDefense)
            statRow(icon: "🎯", name: "precision", value: $vm.precision, addAction: vm.addPrecision,subAction: vm.subPrecision)
            statRow(icon: "💨", name: "evasion", value: $vm.evasion, addAction: vm.addEvasion,subAction: vm.subEvasion)

            Button {
                Task {
                    do {
                        try await vm.depenserPoint()
                        if vm.isLoading == false{
                            vm.attack = 0
                            vm.defense = 0
                            vm.precision = 0
                            vm.evasion = 0
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
    struct StatRow: View {
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


@MainActor
class PointsViewModel: ObservableObject {
    var maxPoints : Int
    @Published var points: Int
    @Published var attack: Int = 0
    @Published var defense: Int = 0
    @Published var precision: Int = 0
    @Published var evasion: Int = 0
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    init(maxPoints: Int) {
        self.maxPoints = maxPoints
        self.points = maxPoints
    }

    func addAttack() {
        guard points > 0 else { return }
        attack += 1
        points -= 1
    }

    func addDefense() {
        guard points > 0 else { return }
        defense += 1
        points -= 1
    }

    func addPrecision() {
        guard points > 0 else { return }
        precision += 1
        points -= 1
    }

    func addEvasion() {
        guard points > 0 else { return }
        evasion += 1
        points -= 1
    }
    
    func subAttack() {
        guard attack > 0 && points < maxPoints else { return }
        attack -= 1
        points += 1
    }


    func subDefense() {
        guard defense > 0 && points < maxPoints else { return }
        defense -= 1
        points += 1
    }

    func subPrecision() {
        guard precision > 0 && points < maxPoints else { return }
        precision -= 1
        points += 1
    }

    func subEvasion() {
        guard evasion > 0 && points < maxPoints else { return }
        evasion -= 1
        points += 1
    }


    var hasSpentPoints: Bool {
        attack > 0 || defense > 0 || precision > 0 || evasion > 0
    }

    func depenserPoint() async throws{
        isLoading = true
        errorMessage = nil

        do {
            try await BarbarianService.shared.spendSkillPoints(
                attack: attack,
                defense: defense,
                precision: precision,
                evasion: evasion)
        } catch NetworkError.pointinsuffisant {
            errorMessage = "Vous n'avez pas assez de points"
        } catch NetworkError.unauthorized {
            errorMessage = "Session expirée."
        } catch {
            errorMessage = "Erreur réseau."
        }
        isLoading = false
    }
    
}

