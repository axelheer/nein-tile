public struct AnyDealer: Dealer, Codable {
    public let dealer: Dealer

    public init(_ dealer: Dealer) {
        self.dealer = dealer
    }

    public func part(_ indices: [TileIndex]) -> [TileIndex] {
        return dealer.part(indices)
    }

    public func next() -> AnyDealer {
        return AnyDealer(dealer.next())
    }

    private enum CodingKeys: String, CodingKey {
        case dealerType
        case deterministic
        case dealer
    }

    private enum DealerTypes: String, Codable {
        case `default`
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let dealerType = try container.decode(DealerTypes.self, forKey: .dealerType)
        let deterministic = try container.decode(Bool.self, forKey: .deterministic)
        switch (dealerType, deterministic) {
        case (.default, false):
            dealer = try container.decode(DefaultDealer<ChaoticGameOfDice>.self, forKey: .dealer)
        case (.default, true):
            dealer = try container.decode(DefaultDealer<NeutralGameOfDice>.self, forKey: .dealer)
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch dealer {
        case let dealer as DefaultDealer<ChaoticGameOfDice>:
            try encode(dealer, dealerType: .default, deterministic: false, to: &container)
        case let dealer as DefaultDealer<NeutralGameOfDice>:
            try encode(dealer, dealerType: .default, deterministic: true, to: &container)
        default:
            throw EncodingError.invalidValue(dealer, .init(
                codingPath: encoder.codingPath, debugDescription: "Dealer out of range"))
        }
    }

    private func encode<T: Dealer & Encodable>(_ dealer: T,
                                               dealerType: DealerTypes,
                                               deterministic: Bool,
                                               to container: inout KeyedEncodingContainer<CodingKeys>) throws {
        try container.encode(dealerType, forKey: .dealerType)
        try container.encode(deterministic, forKey: .deterministic)
        try container.encode(dealer, forKey: .dealer)
    }
}
