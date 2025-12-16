//
//  FightNotificationManager.swift
//  BarbarianGame
//
//  Created by tplocal on 15/12/2025.
//

import Foundation

class FightNotificationManager: ObservableObject {
    static let shared = FightNotificationManager()
    
    @Published var newFightsCount: Int = 0
    
    private let lastCheckKey = "lastFightCheck"
    
    private init() {}
    
    // sauvegarder la date de derniere verification
    func markAsChecked() {
        UserDefaults.standard.set(Date(), forKey: lastCheckKey)
        newFightsCount = 0
    }
    
    // recuperer la date de derniere verification
    func getLastCheckDate() -> Date? {
        return UserDefaults.standard.object(forKey: lastCheckKey) as? Date
    }
    
    // compter les nouveaux combats
    func countNewFights(fights: [FightHistory], myBarbarianId: Int) {
        guard let lastCheck = getLastCheckDate() else {
            // premiere fois, on considere tout comme vu
            markAsChecked()
            return
        }
        
        // formatter pour comparer les dates
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        // compter les combats plus recents que lastCheck
        // ET ou je me suis fait attaquer (pas initie par moi)
        let newCount = fights.filter { fight in
            guard let fightDate = formatter.date(from: fight.createdAt) else {
                return false
            }
            
            let isNewer = fightDate > lastCheck
            let wasAttacked = !fight.didIInitiate(myBarbarianId: myBarbarianId) // si je me suis fait attaquer
            
            if isNewer || wasAttacked {
                print("combat #\(fight.id): nouveau=\(isNewer), attaque=\(wasAttacked), lastCheck=\(lastCheck), date=\(fightDate)")
            }
            
            return isNewer && wasAttacked
        }.count
        
        newFightsCount = newCount
    }
}
