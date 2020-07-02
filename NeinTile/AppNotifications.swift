import SwiftUI
import TileKit

enum AppNotifications: String {
    case controller
    case gameCenter
    
    func post(object: Any?) {
        NotificationCenter.default.post(name: .init(self.rawValue), object: object)
    }
    
    func publisher() -> NotificationCenter.Publisher {
        NotificationCenter.default.publisher(for: .init(self.rawValue))
    }
    
    func observer(_ observer: Any, selector: Selector) {
        NotificationCenter.default.addObserver(observer, selector: selector, name: .init(self.rawValue), object: nil)
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
    case showAchievements
    case showLeaderboard
    case submitEdition(GameEdition, Double)
    case submitTileCount(Int, Double)
    case submitTotalScore(Tournament?, Int)
}
