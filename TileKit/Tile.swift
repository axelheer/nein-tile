public struct Tile: Equatable, Hashable {
    public static let empty = Tile(
        value: 0,
        score: 0
    )
    
    public let value: Int
    public let score: Int
    
    public init(value: Int, score: Int) {
        self.value = value
        self.score = score
    }
}

#if DEBUG
extension Tile: CustomDebugStringConvertible {
    public var debugDescription: String {
        "(\(value), \(score))"
    }
}
#endif
