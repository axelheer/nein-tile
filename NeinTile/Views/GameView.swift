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
                .applyEnding()
                .applyGestures(onFinish: onFinish)
                .drawingGroup()
                .padding()
            if game.current.area.tiles.layCount > 1 {
                LayerView()
                    .padding()
            }
        }
        .accentColor(Color.orange)
        .onAppear() {
            AppNotifications.gameCenter.post(object: GameCenterCommand.authenticate)
        }
    }
    
    func onFinish(_ next: Game) {
        AppNotifications.gameCenter.post(
            object: GameCenterCommand.submitTotalScore(game.tournament, next.score))
        let edition = game.current.maker.edition
        if GameEdition.allCases.contains(edition) {
            let progress = Double(next.score) / Double(10_000)
            AppNotifications.gameCenter.post(
                object: GameCenterCommand.submitEdition(edition, progress))
        }
        let tileCount = next.area.tiles.count
        if achievements.contains(tileCount) {
            let progress = Double(next.score) / Double(tileCount * 10)
            AppNotifications.gameCenter.post(
                object: GameCenterCommand.submitTileCount(tileCount, progress))
        }
        AppNotifications.gameCenter.post(
            object: GameCenterCommand.saveCurrentGame(next)
        )
    }
}

#if DEBUG
struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ForEach(GameSamples.allSamples) { sample in
                GameView()
                    .environmentObject(GameEnvironment(sample))
                    .preferredColorScheme(.dark)
                GameView()
                    .environmentObject(GameEnvironment(sample))
                    .preferredColorScheme(.light)
            }
        }
    }
}
#endif
