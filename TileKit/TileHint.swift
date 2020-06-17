public enum TileHint: Equatable {
    case single(Tile)
    case either(Tile, Tile)
    case threes(Tile, Tile, Tile)
}

#if DEBUG
extension TileHint: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch self {
        case let .single(first):
            return "\(first)"
        case let .either(first, second):
            return "\(first) | \(second)"
        case let .threes(first, second, third):
            return "\(first) | \(second) | \(third)"
        }
    }
}
#endif
