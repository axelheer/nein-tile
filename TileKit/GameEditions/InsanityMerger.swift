// swiftlint:disable identifier_name cyclomatic_complexity

public struct InsanityMerger: Merger {
    public init() {
    }

    public func canMerge(_ source: Tile, _ target: Tile) -> Bool {
        switch (source.value, target.value) {
        case (0, _) where source == .empty:
            return false
        case (_, 0) where target == .empty:
            return true
        case (.min, _):
            return false
        case (_, .min):
            return false
        case (-2, -2):
            return false
        case (-2, -1):
            return true
        case (-1, -2):
            return true
        case (-1, -1):
            return false
        case (1, 1):
            return false
        case (1, 2):
            return true
        case (2, 1):
            return true
        case (2, 2):
            return false
        case (.max, _):
            return false
        case (_, .max):
            return false
        case let (x, y):
            return x == y || x + y == 0
        }
    }

    private let minusOne   = Tile(value: -1, score: 0)
    private let minusTwo   = Tile(value: -2, score: 0)
    private let minusThree = Tile(value: -3, score: 3)

    private let plusOne   = Tile(value: 1, score: 0)
    private let plusTwo   = Tile(value: 2, score: 0)
    private let plusThree = Tile(value: 3, score: 3)

    public func merge(_ source: Tile, _ target: Tile) -> Tile {
        assert(canMerge(source, target), "Cannot merge")

        switch (source, target) {
        case (_, .empty):
            return source
        case (minusTwo, minusOne):
            return minusThree
        case (minusOne, minusTwo):
            return minusThree
        case (plusOne, plusTwo):
            return plusThree
        case (plusTwo, plusOne):
            return plusThree
        case let (x, y) where x.value < 0:
            return Tile(
                value: x.value |+ y.value,
                score: x.score |+ y.score
            )
        case let (x, y) where x.value > 0:
            return Tile(
                value: x.value |+ y.value,
                score: x.score |+ y.score |+ min(x.score, y.score)
            )
        case let (x, y):
            return Tile(
                value: 0,
                score: max(x.score, y.score)
            )
        }
    }
}
