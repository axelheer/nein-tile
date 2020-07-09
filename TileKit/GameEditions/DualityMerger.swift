// swiftlint:disable identifier_name

public struct DualityMerger: Merger {
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
        case (.max, _):
            return false
        case (_, .max):
            return false
        case let (x, y):
            return x == y || x + y == 0
        }
    }

    public func merge(_ source: Tile, _ target: Tile) -> Tile {
        assert(canMerge(source, target), "Cannot merge")

        switch (source, target) {
        case (_, .empty):
            return source
        case let (x, y) where x.value < 0:
            return Tile(
                value: x.value |+ y.value,
                score: x.score |+ y.score
                    |- x.value |- y.value
            )
        case let (x, y) where x.value > 0:
            return Tile(
                value: x.value |+ y.value,
                score: x.score |+ y.score
                    |+ x.value |+ y.value
            )
        case let (x, y):
            return Tile(
                value: 0,
                score: max(x.score, y.score)
            )
        }
    }
}
