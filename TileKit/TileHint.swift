public enum TileHint: Equatable {
    case single(Tile)
    case either(Tile, Tile)
    case threes(Tile, Tile, Tile)
}

extension TileHint: Decodable {
    public init(from decoder: Decoder) throws {
       let tiles = try [Tile](from: decoder)
       switch tiles.count {
       case 1:
           self = .single(tiles[0])
       case 2:
           self = .either(tiles[0], tiles[1])
       case 3:
           self = .threes(tiles[0], tiles[1], tiles[2])
       default:
           fatalError("Count out of range")
       }
   }
}

extension TileHint: Encodable {
    public func encode(to encoder: Encoder) throws {
        switch self {
        case let .single(first):
            try [first].encode(to: encoder)
        case let .either(first, second):
            try [first, second].encode(to: encoder)
        case let .threes(first, second, third):
            try [first, second, third].encode(to: encoder)
        }
    }
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
