import SwiftUI
import TileKit

class GameEnvironment: ObservableObject {
    @Published var tournament: Tournament?
    @Published var current: GameInfo
    @Published var layer: Int
    
    @Published var dragBy: CGSize = .zero
    @Published var magnifyBy: CGFloat = 1
    @Published var preview: GameInfo? = nil
    
    convenience init() {
        self.init(GameMaker().makeGame())
    }
    
    init(_ initialGame: GameInfo) {
        _current = .init(initialValue: initialGame)
        _layer = .init(initialValue: initialGame.area.tiles.layCount - 1)
    }
}

enum Tournament: String, CaseIterable {
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
