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
            if let controller = viewController {
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
        
        if (progress > 1) {
            let achievement = GKAchievement(identifier: "edition_\(edition)")
            achievement.percentComplete = progress
            
            submitAchievement(achievement)
        } else {
            let achievement = GKAchievement(identifier: "noob_\(edition)")
            achievement.percentComplete = 100.0
            
            submitAchievement(achievement)
        }
    }
    
    func submitTileCount(_ tileCount: Int, _ progress: Double) {
        guard Self.enabled else {
            return
        }
        
        let achievement = GKAchievement(identifier: "tiles_\(tileCount)")
        achievement.percentComplete = progress
        
        submitAchievement(achievement)
    }
    
    private func submitAchievement(_ achievement: GKAchievement) {
        achievement.showsCompletionBanner = true
        
        GKAchievement.report([achievement]) { error in
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
