import SwiftUI
import TileKit
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    let gameCenter = GameDelegate()
    let game = GameEnvironment()
    
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        let gameView = GameView()
            .environmentObject(game)
        
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = UIHostingController(rootView: gameView)
            
            AppNotifications.gameCenter.observer(self, selector: #selector(handleGameCenter(notification:)))
            
            self.window = window
            window.makeKeyAndVisible()
        }
    }
    
    @objc func handleGameCenter(notification: NSNotification) {
        guard let rootController = window?.rootViewController else {
            return
        }
        guard let command = notification.object as? GameCenterCommand else {
            return
        }
        
        switch command {
        case .authenticate:
            gameCenter.authenticate(root: rootController)
        case .showAchievements:
            gameCenter.showAchievements(root: rootController)
        case .showLeaderboard:
            gameCenter.showLeaderboard(root: rootController)
        case .submitEdition(let edition, let progress):
            gameCenter.submitEdition(edition, progress)
        case .submitTileCount(let tileCount, let progress):
            gameCenter.submitTileCount(tileCount, progress)
        case .submitTotalScore(let tournament, let totalScore):
            gameCenter.submitTotalScore(tournament, totalScore)
        }
    }
}
