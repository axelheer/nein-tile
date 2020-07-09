import TileKit

final class TestMerger: Merger {
    var onCanMerge: (Tile, Tile) -> Bool = { (_, _) in false }
    func canMerge(_ source: Tile, _ target: Tile) -> Bool {
        return onCanMerge(source, target)
    }

    var onMerge: (Tile, Tile) -> Tile = { (_, _) in .empty }
    func merge(_ source: Tile, _ target: Tile) -> Tile {
        return onMerge(source, target)
    }
}
