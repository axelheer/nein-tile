import TileKit

func makeTestTiles(colCount: Int = 4, rowCount: Int = 4, layCount: Int = 4, score: Int = 0) -> Tiles {
    var value = 1
    var tiles = Tiles(colCount: colCount, rowCount: rowCount, layCount: layCount)
    for lay in 0 ..< layCount {
        for row in 0 ..< rowCount {
            for col in 0 ..< colCount {
                tiles[col, row, lay] = Tile(value: value, score: score)
                value += 1
            }
        }
    }
    return tiles
}
