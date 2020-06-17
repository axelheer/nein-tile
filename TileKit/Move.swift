public struct Move: Equatable, Hashable {
    public static let empty = Move(
        source: .empty,
        target: .empty,
        marker: .empty
    )
    
    public let source: TileIndex
    public let target: TileIndex
    public let marker: TileIndex
    
    public init(source: TileIndex, target: TileIndex, marker: TileIndex) {
        self.source = source
        self.target = target
        self.marker = marker
    }
}

#if DEBUG
extension Move: CustomDebugStringConvertible {
    public var debugDescription: String {
        "\(source) => \(target) (\(marker))"
    }
}
#endif
