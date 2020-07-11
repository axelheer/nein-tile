import SwiftUI
import TileKit

// swiftlint:disable identifier_name multiple_closures_with_trailing_closure

struct HistoryView: View {
    @EnvironmentObject var game: GameEnvironment

    @State private var bounds = [UUID: CGRect]()

    var body: some View {
        NavigationView {
            Form {
                ForEach(game.historicGames) { game in
                    HStack(alignment: .center) {
                        ShareView(game: game.current)
                            .frame(width: 160, height: 160, alignment: .center)
                        Spacer()
                        VStack(alignment: .trailing) {
                            Text(game.title)
                                .font(.headline)
                            Text(game.subtitle)
                                .font(.footnote)
                            Spacer()
                            Text(game.description)
                                .font(.subheadline)
                            Spacer()
                            Button(action: { self.shareIt(game: game) }) {
                                Image(systemName: "square.and.arrow.up")
                                    .padding()
                            }
                            .buttonStyle(BorderlessButtonStyle())
                        }
                    }
                    .onPreferenceChange(ShareBoundsPreferenceKey.self) { bounds in
                        self.bounds[game.id] = bounds
                    }
                }
                .onDelete { indices in
                    for index in indices {
                        let id = self.game.historicGames[index].current.id

                        AppNotifications.gameCenter.post(
                            object: GameCenterCommand.dropSavedGame(id)
                        )
                    }
                }
                if game.gameHistory.count == 0 {
                    Text("There is no game. For now.")
                }
            }
            .navigationBarTitle("Historic games")
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear {
            AppNotifications.gameCenter.post(object: GameCenterCommand.loadSavedGames)
        }
    }

    func shareIt(game: GameEnvironment.GameState) {
        guard let bounds = bounds[game.id] else {
            return
        }

        AppNotifications.shareIt.post(object: ShareCommand.screen(bounds, game.text))
    }
}

extension GameEnvironment.GameState {
    static let format: Formatter = {
        let result = DateFormatter()
        result.dateStyle = .medium
        result.timeStyle = .short
        result.doesRelativeDateFormatting = true
        return result
    }()

    var title: String {
        current.maker.text
    }

    var subtitle: String {
        Self.format.string(for: time)!
    }

    var description: String {
        "\(Tile.format.string(for: current.area.tiles.totalScore)!) points"
    }

    var text: String {
        "I scored \(description)"
    }
}

extension GameMaker {
    var text: String {
        "\(edition.text) (\(colCount) ⨉ \(rowCount) ⨉ \(layCount))"
    }
}

#if DEBUG
struct HistoryView_Previews: PreviewProvider {
    static var gameEnvironment: GameEnvironment = {
        var environment = GameEnvironment()
        for sample in GameSamples.allSamples {
            environment.gameHistory[sample.id] = .init(
                tournament: nil,
                current: sample,
                layer: sample.area.tiles.layCount - 1,
                time: Date()
            )
        }
        return environment
    }()

    static var previews: some View {
        Group {
            HistoryView()
                .preferredColorScheme(.dark)
            HistoryView()
                .preferredColorScheme(.light)
        }
        .environmentObject(gameEnvironment)
    }
}
#endif
