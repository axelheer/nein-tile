// swiftlint:disable cyclomatic_complexity

public struct AnyLottery: Lottery, Codable {
    public let lottery: Lottery

    public init(_ lottery: Lottery) {
        self.lottery = lottery
    }

    public func draw(maxValue: Int) -> (TileHint, Tile)? {
        return lottery.draw(maxValue: maxValue)
    }

    public func next() -> AnyLottery {
        return AnyLottery(lottery.next())
    }

    private enum CodingKeys: String, CodingKey {
        case lotteryType
        case deterministic
        case lottery
    }

    private enum LotteryTypes: String, Codable {
        case simple
        case classic
        case duality
        case insanity
        case fibonacci
        case unlimited
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let lotteryType = try container.decode(LotteryTypes.self, forKey: .lotteryType)
        let deterministic = try container.decode(Bool.self, forKey: .deterministic)
        switch (lotteryType, deterministic) {
        case (.simple, false):
            lottery = try container.decode(SimpleLottery<ChaoticGameOfDice>.self, forKey: .lottery)
        case (.simple, true):
            lottery = try container.decode(SimpleLottery<NeutralGameOfDice>.self, forKey: .lottery)
        case (.classic, false):
            lottery = try container.decode(ClassicLottery<ChaoticGameOfDice>.self, forKey: .lottery)
        case (.classic, true):
            lottery = try container.decode(ClassicLottery<NeutralGameOfDice>.self, forKey: .lottery)
        case (.duality, false):
            lottery = try container.decode(DualityLottery<ChaoticGameOfDice>.self, forKey: .lottery)
        case (.duality, true):
            lottery = try container.decode(DualityLottery<NeutralGameOfDice>.self, forKey: .lottery)
        case (.insanity, false):
            lottery = try container.decode(InsanityLottery<ChaoticGameOfDice>.self, forKey: .lottery)
        case (.insanity, true):
            lottery = try container.decode(InsanityLottery<NeutralGameOfDice>.self, forKey: .lottery)
        case (.fibonacci, false):
            lottery = try container.decode(FibonacciLottery<ChaoticGameOfDice>.self, forKey: .lottery)
        case (.fibonacci, true):
            lottery = try container.decode(FibonacciLottery<NeutralGameOfDice>.self, forKey: .lottery)
        case (.unlimited, false):
            lottery = try container.decode(UnlimitedLottery<ChaoticGameOfDice>.self, forKey: .lottery)
        case (.unlimited, true):
            lottery = try container.decode(UnlimitedLottery<NeutralGameOfDice>.self, forKey: .lottery)
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch lottery {
        case let lottery as SimpleLottery<ChaoticGameOfDice>:
            try encode(lottery, lotteryType: .simple, deterministic: false, to: &container)
        case let lottery as SimpleLottery<NeutralGameOfDice>:
            try encode(lottery, lotteryType: .simple, deterministic: true, to: &container)
        case let lottery as ClassicLottery<ChaoticGameOfDice>:
            try encode(lottery, lotteryType: .classic, deterministic: false, to: &container)
        case let lottery as ClassicLottery<NeutralGameOfDice>:
            try encode(lottery, lotteryType: .classic, deterministic: true, to: &container)
        case let lottery as DualityLottery<ChaoticGameOfDice>:
            try encode(lottery, lotteryType: .duality, deterministic: false, to: &container)
        case let lottery as DualityLottery<NeutralGameOfDice>:
            try encode(lottery, lotteryType: .duality, deterministic: true, to: &container)
        case let lottery as InsanityLottery<ChaoticGameOfDice>:
            try encode(lottery, lotteryType: .insanity, deterministic: false, to: &container)
        case let lottery as InsanityLottery<NeutralGameOfDice>:
            try encode(lottery, lotteryType: .insanity, deterministic: true, to: &container)
        case let lottery as FibonacciLottery<ChaoticGameOfDice>:
            try encode(lottery, lotteryType: .fibonacci, deterministic: false, to: &container)
        case let lottery as FibonacciLottery<NeutralGameOfDice>:
            try encode(lottery, lotteryType: .fibonacci, deterministic: true, to: &container)
        case let lottery as UnlimitedLottery<ChaoticGameOfDice>:
            try encode(lottery, lotteryType: .unlimited, deterministic: false, to: &container)
        case let lottery as UnlimitedLottery<NeutralGameOfDice>:
            try encode(lottery, lotteryType: .unlimited, deterministic: true, to: &container)
        default:
            throw EncodingError.invalidValue(lottery, .init(
                codingPath: encoder.codingPath, debugDescription: "Lottery out of range"))
        }
    }

    private func encode<T: Lottery & Encodable>(_ lottery: T,
                                                lotteryType: LotteryTypes,
                                                deterministic: Bool,
                                                to container: inout KeyedEncodingContainer<CodingKeys>) throws {
        try container.encode(lotteryType, forKey: .lotteryType)
        try container.encode(deterministic, forKey: .deterministic)
        try container.encode(lottery, forKey: .lottery)
    }
}
