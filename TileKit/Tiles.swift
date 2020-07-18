public struct Tiles: Codable {
    public var count: Int {
        colCount * rowCount * layCount
    }

    public let colCount: Int
    public let rowCount: Int
    public let layCount: Int

    private var tiles: [Tile]
    private var merge = [Int: Bool]()
    private var moves = [Int: Int]()

    private enum CodingKeys: String, CodingKey {
        case colCount
        case rowCount
        case layCount

        case tiles
    }

    public init(colCount: Int, rowCount: Int, layCount: Int) {
        precondition(colCount >= 0, "Count out of range")
        precondition(rowCount >= 0, "Count out of range")
        precondition(layCount >= 0, "Count out of range")

        self.colCount = colCount
        self.rowCount = rowCount
        self.layCount = layCount

        tiles = Array(repeating: .empty, count: colCount * rowCount * layCount)
    }

    public init(_ tiles: Tiles) {
        colCount = tiles.colCount
        rowCount = tiles.rowCount
        layCount = tiles.layCount

        self.tiles = Array(tiles.tiles)
    }

    public var minValue: Int {
        tiles.min(by: { $0.value < $1.value })?.value ?? 0
    }

    public var maxValue: Int {
        tiles.max(by: { $0.value < $1.value })?.value ?? 0
    }

    public var totalScore: Int {
        tiles.reduce(0, { $0 |+ $1.score })
    }

    public var indices: [TileIndex] {
        (0 ..< layCount).flatMap { lay in
            (0 ..< rowCount).flatMap { row in
                (0 ..< colCount).map { col in
                    TileIndex(col: col, row: row, lay: lay)
                }
            }
        }
    }

    public func isMerge(_ col: Int, _ row: Int, _ lay: Int) -> Bool {
        return isMerge(TileIndex(col: col, row: row, lay: lay))
    }

    public func isMerge(_ index: TileIndex) -> Bool {
        return merge[actualIndex(index)] ?? false
    }

    public func getMoves(_ col: Int, _ row: Int, _ lay: Int) -> Int {
        return getMoves(TileIndex(col: col, row: row, lay: lay))
    }

    public func getMoves(_ index: TileIndex) -> Int {
        return moves[actualIndex(index)] ?? 0
    }

    public mutating func move(_ tile: Tile, from source: TileIndex, to target: TileIndex, by turn: Int) {
        let targetIndex = actualIndex(target)

        if tiles[targetIndex] != .empty {
            merge[targetIndex] = true
        }

        let sourceIndex = actualIndex(source)

        tiles[sourceIndex] = .empty
        tiles[targetIndex] = tile

        let backtraceIndex = targetIndex + (sourceIndex - targetIndex) * turn

        moves[backtraceIndex] = (moves[backtraceIndex] ?? 0) + 1
    }

    public subscript(col: Int, row: Int, lay: Int) -> Tile {
        get {
            return self[TileIndex(col: col, row: row, lay: lay)]
        }
        set {
            self[TileIndex(col: col, row: row, lay: lay)] = newValue
        }
    }

    public subscript(index: TileIndex) -> Tile {
        get {
            return tiles[actualIndex(index)]
        }
        set {
            tiles[actualIndex(index)] = newValue
        }
    }

    private func actualIndex(_ index: TileIndex) -> Int {
        assert(tiles.count == count, "Corrupt tile count")
        precondition(indexIsValid(index), "Index out of range")

        return index.col + (index.row * colCount) + (index.lay * colCount * rowCount)
    }

    private func indexIsValid(_ index: TileIndex) -> Bool {
        return 0 <= index.col && index.col < colCount
            && 0 <= index.row && index.row < rowCount
            && 0 <= index.lay && index.lay < layCount
    }
}
