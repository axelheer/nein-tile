import CoreGraphics
import Foundation
import TileKit

enum AppNotifications: String {
    case controller
    case gameCenter
    case shareIt

    func post(object: Any?) {
        NotificationCenter.default.post(name: .init(self.rawValue), object: object)
    }
}

enum ControllerCommand {
    case layer(Int)
    case move(MoveDirection)
    case undo

    case nextSample
}

enum GameCenterCommand {
    case authenticate
    case authenticated
    case loadSavedGames
    case dropSavedGame(UUID)
    case saveCurrentGame(Game)
    case savedGameLoaded(Data)
    case showAchievements
    case showLeaderboard
    case submitEdition(GameEdition, Double)
    case submitTileCount(Int, Double)
    case submitTotalScore(Tournament?, Int)
}

enum ShareCommand {
    case screen(CGRect, String)
}
