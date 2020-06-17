public struct Tiles {
    public static let empty = Tiles(
        colCount: 0,
        rowCount: 0,
        layCount: 0
    )
    
    public let count: Int
    
    public let colCount: Int
    public let rowCount: Int
    public let layCount: Int
    
    private var tiles: [Tile]
    private var merge: [Bool]
    private var moves: [Int]
    
    public init(colCount: Int, rowCount: Int, layCount: Int) {
        precondition(colCount >= 0, "Count out of range")
        precondition(rowCount >= 0, "Count out of range")
        precondition(layCount >= 0, "Count out of range")
        
        count = colCount * rowCount * layCount
        
        self.colCount = colCount
        self.rowCount = rowCount
        self.layCount = layCount
        
        tiles = Array(repeating: .empty, count: count)
        merge = Array(repeating: false, count: count)
        moves = Array(repeating: 0, count: count)
    }
    
    public init(_ tiles: Tiles) {
        count = tiles.count
        
        colCount = tiles.colCount
        rowCount = tiles.rowCount
        layCount = tiles.layCount
        
        self.tiles = Array(tiles.tiles)
        
        merge = Array(repeating: false, count: count)
        moves = Array(repeating: 0, count: count)
        
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
    
    public func isMerge(col: Int, row: Int, lay: Int) -> Bool {
        return isMerge(TileIndex(col: col, row: row, lay: lay))
    }
    
    public func isMerge(_ index: TileIndex) -> Bool {
        return merge[actualIndex(index)]
    }
    
    public func getMoves(col: Int, row: Int, lay: Int) -> Int {
        return getMoves(TileIndex(col: col, row: row, lay: lay))
    }
    
    public func getMoves(_ index: TileIndex) -> Int {
        return moves[actualIndex(index)]
    }
    
    public mutating func move(_ tile: Tile, from source: TileIndex, to target: TileIndex, by turn: Int) {
        let sourceIndex = actualIndex(source)
        let targetIndex = actualIndex(target)
        
        if tiles[targetIndex] != .empty {
            merge[targetIndex] = true
        }
        
        tiles[sourceIndex] = .empty
        tiles[targetIndex] = tile
        
        moves[targetIndex + (sourceIndex - targetIndex) * turn] += 1
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
        precondition(indexIsValid(index), "Index out of range")
        
        return index.col + (index.row * colCount) + (index.lay * colCount * rowCount)
    }
    
    private func indexIsValid(_ index: TileIndex) -> Bool {
        return 0 <= index.col && index.col < colCount
            && 0 <= index.row && index.row < rowCount
            && 0 <= index.lay && index.lay < layCount
    }
}
