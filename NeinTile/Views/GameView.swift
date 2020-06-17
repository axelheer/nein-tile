import SwiftUI
import TileKit

struct GameView: View {
    @EnvironmentObject var game: GameEnvironment
    
    let achievements = [
        9,
        12,
        16,
        18,
        24,
        27,
        32,
        36,
        48,
        54,
        64,
        72,
        81,
        96,
        108,
        128,
        144,
        162,
        192,
        216,
        243,
        256,
        288,
        324,
        384,
        432,
        486,
        512,
        576,
        648,
        729,
        768,
        864,
        972,
        1152,
        1296,
        1728
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            DeckView()
                .padding()
            AreaView()
                .padding()
                .applyGameEnding()
                .applyGameGestures(onFinish: onFinish)
            LayerView()
                .padding()
        }
        .applyGameCenter()
        .accentColor(Color.orange)
    }
    
    func onFinish(_ next: GameInfo) {
        if let tournament = game.tournament {
            AppNotifications.gameCenter.post(
                object: GameCenterCommand.tournament(tournament, next.score))
        } else {
            AppNotifications.gameCenter.post(
                object: GameCenterCommand.edition(game.gameMaker.edition, Double(next.score) / 10_000))
            if achievements.contains(next.area.tiles.count) {
                let progress = Double(next.score) / Double(next.area.tiles.count * 10)
                AppNotifications.gameCenter.post(
                    object: GameCenterCommand.tileCount(next.area.tiles.count, progress))
            }
        }
    }
}

#if DEBUG
struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            GameView()
                .preferredColorScheme(.dark)
            GameView()
                .preferredColorScheme(.light)
        }
        .environmentObject(GameEnvironment())
    }
}
#endif
