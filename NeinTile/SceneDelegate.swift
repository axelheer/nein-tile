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
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        guard let data = UserDefaults.standard.data(forKey: "GameState") else {
            return
        }
        guard let state = try? game.load(data: data) else {
            return
        }
        
        if !state.current.done {
            game.tournament = state.tournament
            game.current = state.current
            game.layer = state.layer
        }
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        guard let (_, data) = try? game.save() else {
            return
        }
        
        UserDefaults.standard.set(data, forKey: "GameState")
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
        case .authenticated:
            game.gameCenter = gameCenter.authenticatedPlayer != nil
        case .loadSavedGames:
            gameCenter.loadSavedGames()
        case .dropSavedGame(let id):
            game.gameHistory[id] = nil
            gameCenter.dropSavedGame(id: id)
        case .saveCurrentGame(let next):
            if let (id, data) = try? game.save(next) {
                gameCenter.saveCurrentGame(id: id, data: data)
            }
        case .savedGameLoaded(let data):
            if let state = try? game.load(data: data) {
                game.gameHistory[state.current.id] = state
            }
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
