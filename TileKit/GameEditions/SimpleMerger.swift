public struct SimpleMerger: Merger {
    public init() {
    }
    
    public func canMerge(_ source: Tile, _ target: Tile) -> Bool {
        switch (source.value, target.value) {
        case (0, _):
            return false
        case (_, 0):
            return true
        case (.max, _):
            return false
        case (_, .max):
            return false
        case let (x, y):
            return x == y
        }
    }
    
    public func merge(_ source: Tile, _ target: Tile) -> Tile {
        assert(canMerge(source, target), "Cannot merge")
        
        switch (source, target) {
        case (_, .empty):
            return source
        case let (x, y):
            return Tile(
                value: x.value |+ y.value,
                score: x.score |+ y.score
                    |+ x.value |+ y.value
            )
        }
    }
}
