# 🗡️ Barbarian Game

Application iOS native développée en SwiftUI pour le projet SAM9DNAR - Développement Nomade Natif (2025-2026).

## 📋 Description

**Barbarian Game** est un jeu de combat en ligne où chaque joueur incarne un barbare qui affronte automatiquement les barbares d'autres joueurs. L'objectif n'est pas de contrôler le combat, mais de **gérer la progression** de son barbare en améliorant ses statistiques et en suivant l'historique de ses exploits.

## ✨ Fonctionnalités implémentées

### 🔐 Authentification
- Inscription avec username et mot de passe
- Connexion avec token Bearer
- Déconnexion sécurisée
- Stockage et gestion automatique du token d'authentification

### 🧔 Gestion du barbare
- Création d'un barbare unique avec nom et avatar personnalisé
- Affichage détaillé des statistiques (Attaque, Défense, Précision, Évasion)
- Visualisation du niveau (LOVE), de l'expérience (EXP) et des points de vie
- Distribution des points de compétence gagnés par niveau
- **Suppression et recréation** du barbare (remise à zéro complète)

### ⚔️ Système de combat
- Déclenchement de combats contre des adversaires aléatoires
- Combats entièrement gérés par le serveur
- **Animation progressive** du déroulement du combat round par round
- Affichage des avatars des deux combattants
- Visualisation des dégâts et des esquives
- Gain d'expérience après chaque combat

### 📜 Historique des combats
- Liste complète des combats passés
- Distinction visuelle entre combats initiés (🟠 Attaque) et subis (🔵 Défense)
- **Système de notifications** pour les nouveaux combats défensifs
- Badge indiquant le nombre de combats non consultés
- **Replay animé** des combats passés avec déroulé complet
- Affichage des adversaires avec leurs avatars

### 🏆 Classement
- Leaderboard global des barbares
- Classement basé sur le LOVE puis l'EXP
- Affichage des avatars et statistiques de chaque barbare

## 🏗️ Architecture technique

### Structure du projet

```
BarbarianGame/
├── Models/
│   ├── Avatar.swift          # Modèle pour les avatars
│   ├── Barbarian.swift        # Modèle du barbare avec stats
│   ├── Fight.swift            # Modèles de combat et historique
│   ├── Leaderboard.swift      # Modèle du classement
│   └── User.swift             # Modèles d'authentification
│
├── Services/
│   ├── APIConfig.swift        # Configuration des endpoints
│   ├── NetworkManager.swift   # Gestionnaire HTTP générique
│   ├── AuthService.swift      # Service d'authentification
│   ├── BarbarianService.swift # Service de gestion du barbare
│   └── CombatService.swift    # Service de combat
│
├── Utils/
│   ├── AuthManager.swift              # Singleton pour l'état auth
│   └── FightNotificationManager.swift # Gestion des notifications
│
├── ViewModel/
│   ├── AnimatedFightViewModel.swift   # VM pour combat animé
│   ├── FightReplayViewModel.swift     # VM pour replay
│   ├── FightViewModel.swift           # VM pour combat
│   └── PointViewModel.swift           # VM pour points de compétence
│
└── Views/
    ├── LoginView.swift                # Connexion
    ├── RegisterView.swift             # Inscription
    ├── HomeView.swift                 # Écran d'accueil
    ├── CreateBarbarianView.swift      # Création/Recréation
    ├── BarbarianDetailView.swift      # Détails du barbare
    ├── PointsView.swift               # Dépense de points
    ├── CombatView.swift               # Lancement de combat
    ├── AnimatedFightView.swift        # Combat animé
    ├── FightHistoryView.swift         # Historique des combats
    ├── FightHistoryDetailView.swift   # Détail d'un combat
    ├── FightReplayView.swift          # Replay animé
    ├── FighterView.swift              # Composant barre de vie
    └── LeaderboardView.swift          # Classement
```

### Choix techniques

#### 🎨 SwiftUI
- Framework moderne pour l'interface utilisateur iOS
- Approche déclarative et réactive
- Gestion automatique du cycle de vie des vues

#### 🔄 Architecture
Le projet suit une architecture MVVM (Model-View-ViewModel) classique :
- **Models** : Modèles de données (Barbarian, Fight, Avatar...)
- **Services** : Communication avec l'API
- **ViewModels** : Gestion de la logique métier
- **Views** : Interface SwiftUI

#### 🌐 Networking
- `URLSession` natif avec `async/await`
- Pattern singleton pour les services (`shared`)
- Gestion centralisée des erreurs via `NetworkError`
- Token Bearer automatique dans les headers

#### 💾 Gestion d'état
- `@State` pour l'état local des vues
- `@StateObject` pour les ViewModels
- `@Published` pour la réactivité des données
- `@Environment` pour la navigation et le dismiss

#### ⏱️ Polling
- Timer SwiftUI pour vérifier les nouveaux combats (30 secondes)
- Démarrage/arrêt automatique avec `onAppear`/`onDisappear`
- Optimisation : polling uniquement quand l'app est visible

## 🔌 API utilisée

**URL de base** : `https://vps.vautard.fr/barbarians/ws/`

### Endpoints principaux
- `POST /login.php` - Connexion
- `POST /register.php` - Inscription
- `GET /get_my_barbarian.php` - Récupérer son barbare
- `POST /create_or_reset_barbarian.php` - Créer/Recréer un barbare
- `GET /avatars.php` - Liste des avatars
- `POST /spend_skill_points.php` - Dépenser des points
- `POST /fight.php` - Lancer un combat
- `GET /my_fights.php` - Historique des combats
- `GET /leaderboard.php` - Classement

## 🎯 Fonctionnalités avancées

### Animation des combats
- Affichage **round par round** avec délai de 2 secondes
- Mise à jour progressive des barres de vie
- Scroll automatique vers le dernier round
- Distinction visuelle attaquant/défenseur

### Système de notifications
- Détection automatique des nouveaux combats défensifs
- Badge rouge avec compteur sur le bouton "Historique"
- Sauvegarde de la dernière consultation via `UserDefaults`
- Réinitialisation du badge à l'ouverture de l'historique

### Gestion des avatars
- Chargement asynchrone avec `AsyncImage`
- Cache automatique par SwiftUI
- Placeholder pendant le chargement
- URL construite dynamiquement depuis l'API

### Distinction Attaque/Défense
- **🟠 Orange** : Combats que j'ai initiés
- **🔵 Bleu** : Combats où je me suis fait attaquer
- Badge textuel "Attaque"/"Défense" pour accessibilité

## 🚀 Installation et exécution

### Prérequis
- macOS Sonoma ou supérieur
- Xcode 15.0+
- iOS 17.0+ (simulateur ou device)
- Compte développeur Apple (pour device physique)

### Étapes
1. Cloner le projet
```bash
git clone https://github.com/Abderrahmane01Rhiabi/BarbarianGame.git
cd BarbarianGame
```

2. Ouvrir dans Xcode
```bash
open BarbarianGame.xcodeproj
```

3. Sélectionner un simulateur iPhone
   - iPhone 15 Pro recommandé
   - iOS 17.0 minimum

4. Build et Run
   - `Cmd + R` ou cliquer sur le bouton Play
   - Premier lancement : attendre le téléchargement des dépendances

### Configuration réseau
L'API est déjà configurée. Si besoin de modifier :
```swift
// APIConfig.swift
static let baseURL = "https://vps.vautard.fr/barbarians/ws"
```

## 📱 Captures d'écran

### Écran de connexion
Interface simple avec champs username/password et lien vers inscription.

### Page d'accueil
- Si pas de barbare : bouton "Créer mon barbare"
- Si barbare existant : résumé (nom, niveau, EXP) + bouton d'accès

### Détails du barbare
- Avatar en grand format
- Statistiques complètes (LOVE, EXP, points disponibles)
- Stats de combat (Attaque, Défense, Précision, Évasion)
- Barre de vie visuelle
- Boutons d'action (Points, Combat, Historique, Classement, Supprimer)

### Combat animé
- Avatars des deux combattants
- Barres de vie qui se mettent à jour
- Log détaillé round par round
- Résultat final avec XP gagnée

### Historique
- Liste des combats avec avatars
- Badge "Attaque" (🟠) ou "Défense" (🔵)
- Indicateur Victoire/Défaite
- XP gagnée affichée

## 🐛 Problèmes connus et solutions

### Avatar ne se rafraîchit pas après recréation
**Solution implémentée** : Ajout de `await loadAvatar()` dans `refreshBarbarian()`

### Polling continue en arrière-plan
**Solution** : Utilisation de `onAppear`/`onDisappear` pour démarrer/arrêter le timer

### Délai de rate limiting (429)
**Gestion** : Message explicite à l'utilisateur + disable du bouton temporairement

## 🔮 Améliorations possibles

### Fonctionnalités
- [ ] Mode sombre natif
- [ ] Sons et effets sonores pendant les combats
- [ ] Graphiques de progression (courbe d'XP)
- [ ] Statistiques détaillées (winrate, etc.)
- [ ] Système d'amis
- [ ] Chat entre joueurs

## 👥 Auteurs

**Binôme** : RHIABI Abderrahmane & LE BLOND Nathaniel

**Projet** : SAM9DNAR - Développement Nomade Natif  
**Année** : 2025-2026  
**Université** : Université d'Orléans

## 💡 Ce que nous avons appris

Durant ce projet, nous avons approfondi :
- La gestion asynchrone en Swift avec `async/await`
- L'architecture MVVM dans un contexte SwiftUI
- La communication avec une API REST
- La gestion d'état réactive avec `@Published` et `@State`
- L'animation et les transitions en SwiftUI

Le principal défi a été la gestion du polling et des notifications de nouveaux combats, ainsi que l'animation fluide des combats round par round.

## 🙏 Remerciements

- API fournie par l'équipe pédagogique

---

**Note** : Ce projet a été développé dans un cadre pédagogique. Toute la logique métier est gérée côté serveur, l'application mobile se concentre sur l'interface utilisateur et la communication avec l'API.
