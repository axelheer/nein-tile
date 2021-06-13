import GameKit
import TileKit

// swiftlint:disable identifier_name

class GameDelegate: NSObject, GKGameCenterControllerDelegate {
    var authenticatedPlayer: GKLocalPlayer?

    func authenticate(root rootController: UIViewController) {
        let player = GKLocalPlayer.local
        player.authenticateHandler = { (viewController, error) in
            if let error = error {
                print("Failed to authenticate: \(error.localizedDescription)")
            }

            if let controller = viewController {
                rootController.present(
                    controller,
                    animated: true,
                    completion: nil
                )
            } else if player.isAuthenticated {
                self.authenticatedPlayer = player
            } else {
                self.authenticatedPlayer = nil
            }

            AppNotifications.gameCenter.post(
                object: GameCenterCommand.authenticated
            )
        }
    }

    func loadSavedGames() {
        guard let player = authenticatedPlayer else {
            return
        }

        player.fetchSavedGames { (savedGames, error) in
            if let error = error {
                print("Failed to fetch saved games: \(error.localizedDescription)")
            }

            if let savedGames = savedGames {
                for savedGame in savedGames {
                    savedGame.loadData { (data, error) in
                        if let error = error {
                            print("Failed to fetch saved game: \(error.localizedDescription)")
                        }

                        if let data = data {
                            AppNotifications.gameCenter.post(object: GameCenterCommand.savedGameLoaded(data))
                        }
                    }
                }
            }
        }
    }

    func dropSavedGame(id: UUID) {
        guard let player = authenticatedPlayer else {
            return
        }

        player.deleteSavedGames(withName: id.uuidString) { error in
            if let error = error {
                print("Failed to drop saved game: \(error.localizedDescription)")
            }
        }
    }

    func saveCurrentGame(id: UUID, data: Data) {
        guard let player = authenticatedPlayer else {
            return
        }

        player.saveGameData(data, withName: id.uuidString) { (savedGame, error) in
            if let error = error {
                print("Failed to save game data: \(error.localizedDescription)")
            }

            if savedGame != nil {
                AppNotifications.gameCenter.post(object: GameCenterCommand.savedGameLoaded(data))
            }
        }
    }

    func showAchievements(root rootController: UIViewController) {
        showGameCenter(root: rootController, viewState: .achievements)
    }

    func showLeaderboard(root rootController: UIViewController) {
        showGameCenter(root: rootController, viewState: .leaderboards)
    }

    private func showGameCenter(root rootController: UIViewController, viewState: GKGameCenterViewControllerState) {
        let controller = GKGameCenterViewController()
        controller.gameCenterDelegate = self
        controller.viewState = viewState

        rootController.present(
            controller,
            animated: true,
            completion: nil
        )
    }

    func submitEdition(_ edition: GameEdition, _ progress: Double) {
        var achievements = [GKAchievement]()

        if progress < 1 {
            let noob = GKAchievement(identifier: "noob_\(edition)")
            noob.percentComplete = 100.0

            achievements.append(noob)
        }

        if progress >= 1 {
            let apprentice = GKAchievement(identifier: "apprentice_\(edition)")
            apprentice.percentComplete = 100.0

            achievements.append(apprentice)
        }

        if progress >= 10 {
            let fellow = GKAchievement(identifier: "fellow_\(edition)")
            fellow.percentComplete = 100.0

            achievements.append(fellow)
        }

        if progress >= 25 {
            let mistress = GKAchievement(identifier: "mistress_\(edition)")
            mistress.percentComplete = 100.0

            achievements.append(mistress)
        }

        let edition = GKAchievement(identifier: "edition_\(edition)")
        edition.percentComplete = progress

        achievements.append(edition)

        submitAchievements(achievements)
    }

    func submitTileCount(_ tileCount: Int, _ progress: Double) {
        let achievement = GKAchievement(identifier: "tiles_\(tileCount)")
        achievement.percentComplete = progress

        submitAchievements([achievement])
    }

    private func submitAchievements(_ achievements: [GKAchievement]) {
        for achievement in achievements {
            achievement.showsCompletionBanner = true
        }

        GKAchievement.report(achievements) { error in
            if let error = error {
                print("Failed to submit achievement: \(error.localizedDescription)")
            }
        }
    }

    func submitTotalScore(_ tournament: Tournament?, _ totalScore: Int) {
        let score = GKScore(leaderboardIdentifier: tournament?.rawValue ?? "custom")
        score.value = Int64(totalScore)
        score.context = 0

        GKScore.report([score]) { error in
            if let error = error {
                print("Failed to submit score: \(error.localizedDescription)")
            }
        }
    }

    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }
}
