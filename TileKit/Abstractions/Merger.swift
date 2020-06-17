public protocol Merger {
    func canMerge(_ source: Tile, _ target: Tile) -> Bool
    func merge(_ source: Tile, _ target: Tile) -> Tile
}
