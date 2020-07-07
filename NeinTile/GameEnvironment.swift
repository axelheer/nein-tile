import Combine
import CoreGraphics
import Foundation
import TileKit

class GameEnvironment: ObservableObject {
    @Published var tournament: Tournament?
    @Published var current: Game
    @Published var layer: Int
    
    @Published var dragBy: CGSize = .zero
    @Published var magnifyBy: CGFloat = 1
    @Published var preview: Game?
    
    @Published var gameCenter: Bool = false
    @Published var gameHistory: [UUID: GameState] = .init()
    
    convenience init() {
        self.init(GameMaker().makeGame())
    }
    
    init(_ initial: Game) {
        _current = .init(initialValue: initial)
        _layer = .init(initialValue: initial.area.tiles.layCount - 1)
    }
    
    struct GameState: Codable {
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
        
        tournament = state.tournament
        if !state.current.done {
            current = state.current
            layer = state.layer
        } else {
            current = state.current.maker.makeGame()
            layer = current.area.tiles.layCount - 1
        }
    }
    
    func backup() {
        guard let (_, data) = try? save() else {
            return
        }
        
        UserDefaults.standard.set(data, forKey: "GameState")
    }
    
    func save(_ next: Game? = nil) throws -> (UUID, Data) {
        let state = GameState(
            tournament: tournament,
            current: next ?? current,
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
