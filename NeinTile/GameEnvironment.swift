import SwiftUI
import TileKit

class GameEnvironment: ObservableObject {
    @Published private(set) var tournament: Tournament?
    @Published private(set) var current: Game
    @Published private(set) var layer: Int

    @Published private(set) var dragBy: CGSize = .zero
    @Published private(set) var magnifyBy: CGFloat = 1
    @Published private(set) var moveTo: MoveDirection?
    @Published private(set) var preview: Game?

    @Published var gameCenter: Bool = false
    @Published var gameHistory: [UUID: GameState] = .init() {
        didSet {
            historicGames = gameHistory.values.sorted { (left, right) in
                left.time > right.time
            }
        }
    }

    private(set) var historicGames: [GameState] = .init()

    convenience init() {
        self.init(GameMaker().makeGame())
    }

    init(_ initial: Game, tournament: Tournament? = nil) {
        _tournament = .init(initialValue: tournament)
        _current = .init(initialValue: initial)
        _layer = .init(initialValue: initial.area.tiles.layCount - 1)
    }

    func reset(_ game: Game, tournament: Tournament? = nil, layer: Int? = nil, using undoManager: UndoManager? = nil) {
        self.tournament = tournament
        self.current = game
        self.layer = layer ?? game.area.tiles.layCount - 1

        dragBy = .zero
        magnifyBy = 1
        moveTo = nil
        preview = nil

        undoManager?.removeAllActions(withTarget: self)
    }

    func show(layer: Int) {
        dragBy = .zero
        magnifyBy = 1
        moveTo = nil
        preview = nil

        if layer < current.area.tiles.layCount {
            withAnimation {
                self.layer = layer
            }
        }
    }

    func show(dragBy: CGSize = .zero, magnifyBy: CGFloat = 1, to direction: MoveDirection) {
        if self.moveTo != direction {
            self.preview = current.view(
                to: direction
            )
            self.moveTo = direction
        }
        self.dragBy = dragBy
        self.magnifyBy = magnifyBy
    }

    func move(to direction: MoveDirection, using undoManager: UndoManager? = nil) {
        if let next = current.move(to: direction) {
            if current.done != next.done {
                onFinish(next)
            }
            if current.maker.apprentice {
                let last = current
                undoManager?.registerUndo(withTarget: self) { game in
                    game.current = last
                }
            }
            if let preview = preview {
                current = preview
            }
            backout()
            withAnimation {
                current = next
            }
            backup(next)
        } else {
            backout()
        }
    }

    func backout() {
        moveTo = nil
        preview = nil
        dragBy = .zero
        magnifyBy = 1
    }

    private func onFinish(_ next: Game) {
        AppNotifications.gameCenter.post(
            object: GameCenterCommand.submitTotalScore(tournament, next.area.tiles.totalScore))
        let edition = next.maker.edition
        if GameEdition.allCases.contains(edition) {
            let progress = Double(next.area.tiles.totalScore) / Double(10_000)
            AppNotifications.gameCenter.post(
                object: GameCenterCommand.submitEdition(edition, progress))
        }
        let tileCount = next.area.tiles.count
        if achievements.contains(tileCount) {
            let progress = Double(next.area.tiles.totalScore) / Double(tileCount * 10)
            AppNotifications.gameCenter.post(
                object: GameCenterCommand.submitTileCount(tileCount, progress))
        }
        AppNotifications.gameCenter.post(
            object: GameCenterCommand.saveCurrentGame(next)
        )
    }
}

// swiftlint:disable identifier_name

extension GameEnvironment {
    struct GameState: Codable, Identifiable {
        var id: UUID {
            current.id
        }

        let tournament: Tournament?
        let current: Game
        let layer: Int
        let time: Date
    }

    func restore() {
        guard let data = UserDefaults.standard.data(forKey: "GameState") else {
            return
        }
        guard let state = try? load(data: data) else {
            return
        }

        if !state.current.done {
            reset(state.current, tournament: state.tournament, layer: state.layer)
        } else {
            reset(state.current.maker.makeGame(), tournament: state.tournament)
        }
    }

    func backup(_ next: Game) {
        guard let (_, data) = try? save(next) else {
            return
        }

        UserDefaults.standard.set(data, forKey: "GameState")
    }

    func save(_ next: Game) throws -> (UUID, Data) {
        let state = GameState(
            tournament: tournament,
            current: next,
            layer: layer,
            time: Date()
        )

        let encoder = JSONEncoder()
        let data = try encoder.encode(state)

        return (state.current.id, data)
    }

    func load(data: Data) throws -> GameState {
        let decoder = JSONDecoder()
        let state = try decoder.decode(GameState.self, from: data)

        return state
    }
}

// swiftlint:disable function_body_length cyclomatic_complexity

enum Tournament: String, CaseIterable, Codable {
    case simple_2d,
         simple_3d,
         classic_2d,
         classic_3d,
         duality_2d,
         duality_3d,
         insanity_2d,
         insanity_3d,
         fibonacci_2d,
         fibonacci_3d,
         simple_2d_max,
         simple_3d_max,
         classic_2d_max,
         classic_3d_max,
         duality_2d_max,
         duality_3d_max,
         insanity_2d_max,
         insanity_3d_max,
         fibonacci_2d_max,
         fibonacci_3d_max

    func start() -> GameMaker {
        switch self {
        case .simple_2d:
            return GameMaker()
                .use(edition: .simple)
                .use(colCount: 4, rowCount: 4)
                .be(deterministic: false)
                .be(apprentice: false)
                .be(slippery: true)
        case .simple_3d:
            return GameMaker()
                .use(edition: .simple)
                .use(colCount: 4, rowCount: 4, layCount: 4)
                .be(deterministic: false)
                .be(apprentice: false)
                .be(slippery: true)
        case .classic_2d:
            return GameMaker()
                .use(edition: .classic)
                .use(colCount: 4, rowCount: 4)
                .be(deterministic: false)
                .be(apprentice: false)
                .be(slippery: false)
        case .classic_3d:
            return GameMaker()
                .use(edition: .classic)
                .use(colCount: 4, rowCount: 4, layCount: 4)
                .be(deterministic: false)
                .be(apprentice: false)
                .be(slippery: false)
        case .duality_2d:
            return GameMaker()
                .use(edition: .duality)
                .use(colCount: 5, rowCount: 5)
                .be(deterministic: false)
                .be(apprentice: false)
                .be(slippery: true)
        case .duality_3d:
            return GameMaker()
                .use(edition: .duality)
                .use(colCount: 5, rowCount: 5, layCount: 5)
                .be(deterministic: false)
                .be(apprentice: false)
                .be(slippery: true)
        case .insanity_2d:
            return GameMaker()
                .use(edition: .insanity)
                .use(colCount: 5, rowCount: 5)
                .be(deterministic: false)
                .be(apprentice: false)
                .be(slippery: false)
        case .insanity_3d:
            return GameMaker()
                .use(edition: .insanity)
                .use(colCount: 5, rowCount: 5, layCount: 5)
                .be(deterministic: false)
                .be(apprentice: false)
                .be(slippery: false)
        case .fibonacci_2d:
            return GameMaker()
                .use(edition: .fibonacci)
                .use(colCount: 3, rowCount: 3)
                .be(deterministic: false)
                .be(apprentice: false)
                .be(slippery: true)
        case .fibonacci_3d:
            return GameMaker()
                .use(edition: .fibonacci)
                .use(colCount: 3, rowCount: 3, layCount: 3)
                .be(deterministic: false)
                .be(apprentice: false)
                .be(slippery: true)
        case .simple_2d_max:
            return GameMaker()
                .use(edition: .simple)
                .use(colCount: 8, rowCount: 8)
                .be(deterministic: false)
                .be(apprentice: false)
                .be(slippery: true)
        case .simple_3d_max:
            return GameMaker()
                .use(edition: .simple)
                .use(colCount: 8, rowCount: 8, layCount: 8)
                .be(deterministic: false)
                .be(apprentice: false)
                .be(slippery: true)
        case .classic_2d_max:
            return GameMaker()
                .use(edition: .classic)
                .use(colCount: 8, rowCount: 8)
                .be(deterministic: false)
                .be(apprentice: false)
                .be(slippery: false)
        case .classic_3d_max:
            return GameMaker()
                .use(edition: .classic)
                .use(colCount: 8, rowCount: 8, layCount: 8)
                .be(deterministic: false)
                .be(apprentice: false)
                .be(slippery: false)
        case .duality_2d_max:
            return GameMaker()
                .use(edition: .duality)
                .use(colCount: 10, rowCount: 10)
                .be(deterministic: false)
                .be(apprentice: false)
                .be(slippery: true)
        case .duality_3d_max:
            return GameMaker()
                .use(edition: .duality)
                .use(colCount: 10, rowCount: 10, layCount: 10)
                .be(deterministic: false)
                .be(apprentice: false)
                .be(slippery: true)
        case .insanity_2d_max:
            return GameMaker()
                .use(edition: .insanity)
                .use(colCount: 10, rowCount: 10)
                .be(deterministic: false)
                .be(apprentice: false)
                .be(slippery: false)
        case .insanity_3d_max:
            return GameMaker()
                .use(edition: .insanity)
                .use(colCount: 10, rowCount: 10, layCount: 10)
                .be(deterministic: false)
                .be(apprentice: false)
                .be(slippery: false)
        case .fibonacci_2d_max:
            return GameMaker()
                .use(edition: .fibonacci)
                .use(colCount: 6, rowCount: 6)
                .be(deterministic: false)
                .be(apprentice: false)
                .be(slippery: true)
        case .fibonacci_3d_max:
            return GameMaker()
                .use(edition: .fibonacci)
                .use(colCount: 6, rowCount: 6, layCount: 6)
                .be(deterministic: false)
                .be(apprentice: false)
                .be(slippery: true)
        }
    }
}

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
