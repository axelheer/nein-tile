// swiftlint:disable identifier_name

public struct FibonacciMerger: Merger {
    public init() {
    }

    public func canMerge(_ source: Tile, _ target: Tile) -> Bool {
        switch (source.value, target.value) {
        case (0, _):
            return false
        case (_, 0):
            return true
        case (1, 1):
            return true
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
            return (x < y && x + x > y)
                || (y < x && y + y > x)
        }
    }

    private let one = Tile(value: 1, score: 0)
    private let two = Tile(value: 2, score: 0)

    public func merge(_ source: Tile, _ target: Tile) -> Tile {
        assert(canMerge(source, target), "Cannot merge")

        switch (source, target) {
        case (_, .empty):
            return source
        case (one, one):
            return two
        case let (x, y):
            return Tile(
                value: x.value |+ y.value,
                score: x.score |+ y.score
                    |+ x.value |+ y.value
            )
        }
    }
}
