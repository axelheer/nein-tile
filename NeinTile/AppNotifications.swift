import SwiftUI
import TileKit

enum AppNotifications: String {
    case gameCenter
    case gameCenterError
    case keyCommand
    
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

enum KeyCommand {
    case layer(Int)
    case move(MoveDirection)
    case undo
}

enum GameCenterCommand {
    case authenticate
    case achievements
    case leaderboard
    case edition(GameEdition, Double)
    case tileCount(Int, Double)
    case tournament(Tournament, Int)
}
