public struct AnyMerger: Merger, Codable {
    public let merger: Merger
    
    public init(_ merger: Merger) {
        self.merger = merger
    }
    
    public func canMerge(_ source: Tile, _ target: Tile) -> Bool {
        return merger.canMerge(source, target)
    }
    
    public func merge(_ source: Tile, _ target: Tile) -> Tile {
        return merger.merge(source, target)
    }
    
    private enum CodingKeys: String, CodingKey {
        case mergerType
    }
    
    private enum MergerTypes: String, Codable {
        case simple
        case classic
        case duality
        case insanity
        case fibonacci
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let mergerType = try container.decode(MergerTypes.self, forKey: .mergerType)
        switch mergerType {
        case .simple:
            merger = SimpleMerger()
        case .classic:
            merger = ClassicMerger()
        case .duality:
            merger = DualityMerger()
        case .insanity:
            merger = InsanityMerger()
        case .fibonacci:
            merger = FibonacciMerger()
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch merger {
        case _ as SimpleMerger:
            try container.encode(MergerTypes.simple, forKey: .mergerType)
        case _ as ClassicMerger:
            try container.encode(MergerTypes.classic, forKey: .mergerType)
        case _ as DualityMerger:
            try container.encode(MergerTypes.duality, forKey: .mergerType)
        case _ as InsanityMerger:
            try container.encode(MergerTypes.insanity, forKey: .mergerType)
        case _ as FibonacciMerger:
            try container.encode(MergerTypes.fibonacci, forKey: .mergerType)
        default:
            throw EncodingError.invalidValue(merger, .init(
                codingPath: encoder.codingPath, debugDescription: "Merger out of range"))
        }
    }
}
