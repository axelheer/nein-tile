import SwiftUI
import TileKit
import UIKit

// swiftlint:disable line_length cyclomatic_complexity identifier_name

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    let gameCenter = GameDelegate()
    let game = GameEnvironment()

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        game.restore()

        let gameView = GameView()
            .environmentObject(game)

        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = UIHostingController(rootView: gameView)

            NotificationCenter.default.addObserver(
                self,
                selector: #selector(handleGameCenter(notification:)),
                name: .init(AppNotifications.gameCenter.rawValue),
                object: nil
            )
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(handleShareIt(notification:)),
                name: .init(AppNotifications.shareIt.rawValue),
                object: nil
            )

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
        case .authenticated:
            game.gameCenter = gameCenter.authenticatedPlayer != nil
            game.isHarald = gameCenter.authenticatedPlayer?
                .gamePlayerID == "A:_3004ce4cfbd994d13f0dc57769f63e5d"
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

    @objc func handleShareIt(notification: NSNotification) {
        guard let rootController = window?.rootViewController else {
            return
        }
        guard let command = notification.object as? ShareCommand else {
            return
        }

        switch command {
        case .screen(let bounds, let text):
            let controller = rootController.presentedViewController ?? rootController
            guard let view = controller.view else {
                break
            }

            let bounds = view.convert(bounds, from: nil)
            let renderer = UIGraphicsImageRenderer(bounds: bounds)
            let image = renderer.image { context in
                view.layer.render(in: context.cgContext)
            }

            let activityController = UIActivityViewController(
                activityItems: [
                    URL(string: "https://apps.apple.com/app/nein-tile/id1518189085")!,
                    image,
                    text
                ],
                applicationActivities: nil
            )

            if let popover = activityController.popoverPresentationController {
                popover.sourceView = view
                popover.sourceRect = bounds
            }

            controller.present(
                activityController,
                animated: true,
                completion: nil
            )
        }
    }
}
