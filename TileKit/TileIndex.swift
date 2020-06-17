public struct TileIndex: Equatable, Hashable {
    public static let empty = TileIndex(
        col: 0,
        row: 0,
        lay: 0
    )
    
    public let col: Int
    public let row: Int
    public let lay: Int
    
    public init(col: Int, row: Int, lay: Int) {
        self.col = col
        self.row = row
        self.lay = lay
    }
}

#if DEBUG
extension TileIndex: CustomDebugStringConvertible {
    public var debugDescription: String {
        "[\(col), \(row), \(lay)]"
    }
}
#endif
