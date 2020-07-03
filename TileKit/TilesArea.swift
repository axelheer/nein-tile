public struct TilesArea: Codable {
    public let dealer: AnyDealer
    public let merger: AnyMerger
    
    public let tiles: Tiles
    
    public init(tiles: Tiles, dealer: AnyDealer, merger: AnyMerger) {
        self.tiles = tiles
        self.dealer = dealer
        self.merger = merger
    }
    
    public func canMove(to direction: MoveDirection) -> Bool {
        var iterator = MoveIterator(tiles: tiles, direction: direction)
        while let move = iterator.next() {
            let source = tiles[move.source]
            let target = tiles[move.target]
            if merger.canMerge(source, target) {
                return true
            }
        }
        return false
    }
    
    public func move(to direction: MoveDirection, slippery: Bool, nextTile: Tile) -> TilesArea {
        var next = Tiles(tiles)
        var markers = [TileIndex]()
        var mergedEverything = false
        var slipperyTurn = 0
        
        repeat {
            slipperyTurn += 1
            mergedEverything = true
            var iterator = MoveIterator(tiles: next, direction: direction)
            while let move = iterator.next() {
                guard !next.isMerge(move.source) else {
                    continue
                }
                guard !next.isMerge(move.target) else {
                    continue
                }
                let source = next[move.source]
                let target = next[move.target]
                if merger.canMerge(source, target) {
                    let merged = merger.merge(source, target)
                    next.move(merged, from: move.source, to: move.target,
                              by: slipperyTurn
                    )
                    if !markers.contains(move.marker) {
                        markers.append(move.marker)
                    }
                    mergedEverything = false
                }
            }
        } while slippery && !mergedEverything
        
        guard !markers.isEmpty else {
            fatalError("Invalid move")
        }
        
        if slippery {
            let freeIndices = next.indices.filter { index in
                next[index] == .empty
            }
            for index in dealer.part(dealer.part(freeIndices)) {
                next[index] = nextTile
            }
        } else {
            for marker in dealer.part(markers) {
                next[marker] = nextTile
            }
        }
        
        return TilesArea(
            tiles: next,
            dealer: dealer.next(),
            merger: merger
        )
    }
}
