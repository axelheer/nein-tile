import SwiftUI
import TileKit

struct GameView: View {
    @Environment (\.colorScheme) var colorScheme

    @EnvironmentObject var game: GameEnvironment

    var background: Color {
        colorScheme == .dark ? .black : .white
    }

    var body: some View {
        VStack(spacing: 0) {
            DeckView()
                .padding()
            AreaView()
                .padding()
                .applyGestures()
                .applyEnding()
            if game.current.area.tiles.layCount > 1 {
                LayerView()
                    .padding()
            }
        }
        .accentColor(Color.orange)
        .background(background)
        .onAppear {
            AppNotifications.gameCenter.post(object: GameCenterCommand.authenticate)
        }
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
