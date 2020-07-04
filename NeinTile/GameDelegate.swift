import GameKit
import TileKit

class GameDelegate: NSObject, GKGameCenterControllerDelegate {
    static var enabled: Bool {
        GKLocalPlayer.local.isAuthenticated
    }
    
    func authenticate(root rootController: UIViewController) {
        GKLocalPlayer.local.authenticateHandler = { (viewController, error) in
            if let e = error {
                print("Failed to authenticate: \(e.localizedDescription)")
            }
            else if let controller = viewController {
                rootController.present(
                    controller,
                    animated: true,
                    completion: nil
                )
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
        guard Self.enabled else {
            return
        }
        
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
        guard Self.enabled else {
            return
        }
        
        var achievements = [GKAchievement]()
        
        if (progress < 1) {
            let noob = GKAchievement(identifier: "noob_\(edition)")
            noob.percentComplete = 100.0
            
            achievements.append(noob)
        }
        
        let apprentice = GKAchievement(identifier: "apprentice_\(edition)")
        apprentice.percentComplete = progress * 10.0
        
        achievements.append(apprentice)
        
        let mistress = GKAchievement(identifier: "mistress_\(edition)")
        mistress.percentComplete = progress * 4.0
        
        achievements.append(mistress)
        
        let edition = GKAchievement(identifier: "edition_\(edition)")
        edition.percentComplete = progress
        
        achievements.append(edition)
        
        submitAchievements(achievements)
    }
    
    func submitTileCount(_ tileCount: Int, _ progress: Double) {
        guard Self.enabled else {
            return
        }
        
        let achievement = GKAchievement(identifier: "tiles_\(tileCount)")
        achievement.percentComplete = progress
        
        submitAchievements([achievement])
    }
    
    private func submitAchievements(_ achievements: [GKAchievement]) {
        for achievement in achievements {
            achievement.showsCompletionBanner = true
        }
        
        GKAchievement.report(achievements) { error in
            if let e = error {
                print("Failed to submit achievement: \(e.localizedDescription)")
            }
        }
    }
    
    func submitTotalScore(_ tournament: Tournament?, _ totalScore: Int) {
        guard Self.enabled else {
            return
        }
        
        let score = GKScore(leaderboardIdentifier: tournament?.rawValue ?? "custom")
        score.value = Int64(totalScore)
        score.context = 0
        
        GKScore.report([score]) { error in
            if let e = error {
                print("Failed to submit score: \(e.localizedDescription)")
            }
        }
    }
    
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }
}
