// swiftlint:disable identifier_name

public struct ClassicMerger: Merger {
    public init() {
    }

    public func canMerge(_ source: Tile, _ target: Tile) -> Bool {
        switch (source.value, target.value) {
        case (0, _):
            return false
        case (_, 0):
            return true
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
            return x == y
        }
    }

    private let one   = Tile(value: 1, score: 0)
    private let two   = Tile(value: 2, score: 0)
    private let three = Tile(value: 3, score: 3)

    public func merge(_ source: Tile, _ target: Tile) -> Tile {
        assert(canMerge(source, target), "Cannot merge")

        switch (source, target) {
        case (_, .empty):
            return source
        case (one, two):
            return three
        case (two, one):
            return three
        case let (x, y):
            return Tile(
                value: x.value |+ y.value,
                score: x.score |+ y.score |+ y.score
            )
        }
    }
}
