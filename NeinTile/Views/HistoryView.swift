import SwiftUI
import TileKit

struct HistoryView: View {
    @EnvironmentObject var game: GameEnvironment
    
    var body: some View {
        NavigationView {
            Form {
                List {
                    makeListBody()
                }
            }
            .navigationBarTitle("Historic games")
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear() {
            AppNotifications.gameCenter.post(object: GameCenterCommand.loadSavedGames)
        }
    }
    
    func makeListBody() -> some View {
        let historicGames = game.gameHistory.values
            .sorted(by: { $0.time > $1.time })
            .map { state -> (game: GameEnvironment, time: Date) in
            let environment = GameEnvironment()
            environment.tournament = state.tournament
            environment.current = state.current
            environment.layer = state.layer
            return (environment, state.time)
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
                    Text(Tile.format.string(for: game.current.score)!)
                        .font(.subheadline)
                }
            }
        }
        .onDelete() { indices in
            for index in indices {
                let id = historicGames[index].game.current.id
                
                AppNotifications.gameCenter.post(
                    object: GameCenterCommand.dropSavedGame(id)
                )
            }
        }
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
        .accentColor(Color.orange)
        .environmentObject(gameEnvironment)
    }
}
#endif
