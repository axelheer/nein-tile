import SwiftUI
import TileKit

struct MakeView: View {
    @Environment(\.undoManager) var undoManager
    @Environment(\.presentationMode) var presentationMode

    @EnvironmentObject var game: GameEnvironment

    @State private var edition: GameEdition

    @State private var colCount: Int
    @State private var rowCount: Int
    @State private var layCount: Int

    @State private var deterministic: Bool
    @State private var apprentice: Bool
    @State private var slippery: Bool

    @State private var currentTab: TabKeys
    @State private var tournament: Tournament

    init(previous: Game, tournament: Tournament?) {
        _edition = .init(initialValue: previous.maker.edition)

        _colCount = .init(initialValue: previous.maker.colCount)
        _rowCount = .init(initialValue: previous.maker.rowCount)
        _layCount = .init(initialValue: previous.maker.layCount)

        _deterministic = .init(initialValue: previous.maker.deterministic)
        _apprentice = .init(initialValue: previous.maker.apprentice)
        _slippery = .init(initialValue: previous.maker.slippery)

        if let tournament = tournament {
            _tournament = .init(initialValue: tournament)
            _currentTab = .init(initialValue: .tournament)
        } else {
            _tournament = .init(initialValue: .simple_2d)
            _currentTab = .init(initialValue: .custom)
        }
    }

    enum TabKeys: String {
        case custom
        case tournament
        case historic
    }

    var body: some View {
        TabView(selection: $currentTab) {
            CustomView(
                edition: $edition,
                colCount: $colCount,
                rowCount: $rowCount,
                layCount: $layCount,
                deterministic: $deterministic,
                apprentice: $apprentice,
                slippery: $slippery,
                onStart: startGame
            )
            .tabItem {
                Image(systemName: "wrench")
                Text("Custom game")
            }
            .tag(TabKeys.custom)
            TournamentView(
                tournament: $tournament,
                onStart: startGame
            )
            .tabItem {
                Image(systemName: "globe")
                Text("Tournament game")
            }
            .tag(TabKeys.tournament)
            if game.gameCenter {
                HistoryView()
                .tabItem {
                    Image(systemName: "clock")
                    Text("Historic games")
                }
                .tag(TabKeys.historic)
            }
        }
    }

    func startGame() {
        let next = currentTab != .tournament
            ? GameMaker()
                .use(edition: edition)
                .use(colCount: colCount, rowCount: rowCount, layCount: layCount)
                .be(deterministic: deterministic)
                .be(apprentice: apprentice)
                .be(slippery: slippery)
            : tournament.start()

        game.reset(next.makeGame(), tournament: currentTab == .tournament ? tournament : nil, using: undoManager)

        presentationMode.wrappedValue.dismiss()
    }
}

#if DEBUG
struct MakeView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MakeView(previous: GameMaker().makeGame(), tournament: nil)
                .preferredColorScheme(.dark)
            MakeView(previous: GameMaker().makeGame(), tournament: .simple_2d)
                .preferredColorScheme(.light)
        }
        .environmentObject(GameEnvironment())
    }
}
#endif
