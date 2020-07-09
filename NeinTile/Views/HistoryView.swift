import SwiftUI
import TileKit

// swiftlint:disable identifier_name multiple_closures_with_trailing_closure

struct HistoryView: View {
    @EnvironmentObject var game: GameEnvironment

    @State private var bounds = [UUID: CGRect]()

    var body: some View {
        NavigationView {
            Form {
                if game.gameHistory.count != 0 {
                    makeListBody()
                } else {
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

    func makeListBody() -> some View {
        let historicGames = game.gameHistory.values
            .sorted(by: { $0.time > $1.time })
            .map { state -> (game: GameEnvironment, time: Date) in
                (GameEnvironment(state.current, tournament: state.tournament), state.time)
        }

        let format = DateFormatter()
        format.dateStyle = .medium
        format.timeStyle = .short
        format.doesRelativeDateFormatting = true

        return ForEach(historicGames, id: \.game.current.id) { (game, time) in
            HStack(alignment: .center) {
                AreaView()
                    .frame(width: 160, height: 160, alignment: .center)
                    .environmentObject(game)
                Spacer()
                VStack(alignment: .trailing) {
                    Text(game.current.maker.text)
                        .font(.headline)
                    Text(format.string(for: time)!)
                        .font(.footnote)
                    Spacer()
                    Text("\(Tile.format.string(for: game.current.area.tiles.totalScore)!) points")
                        .font(.subheadline)
                    Spacer()
                    Button(action: { self.shareIt(id: game.current.id, score: game.current.area.tiles.totalScore) }) {
                        Image(systemName: "square.and.arrow.up")
                            .padding()
                    }
                    .buttonStyle(BorderlessButtonStyle())
                }
            }
            .onPreferenceChange(TilesBoundsPreferenceKey.self) { bounds in
                self.bounds[game.current.id] = bounds
            }
        }
        .onDelete { indices in
            for index in indices {
                let id = historicGames[index].game.current.id

                AppNotifications.gameCenter.post(
                    object: GameCenterCommand.dropSavedGame(id)
                )
            }
        }
    }

    func shareIt(id: UUID, score: Int) {
        guard let bounds = bounds[id] else {
            return
        }

        let text = "I scored \(Tile.format.string(for: score)!) points"

        AppNotifications.shareIt.post(object: ShareCommand.screen(bounds, text))
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
