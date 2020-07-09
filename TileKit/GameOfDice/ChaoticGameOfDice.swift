public struct ChaoticGameOfDice: GameOfDiceProtocol {
    private static var random = SystemRandomNumberGenerator()

    private let seed: UInt64

    public init() {
        seed = Self.random.next()
    }

    public func roll() -> some RandomNumberGenerator {
        return PcgRandom(seed: seed)
    }

    public func next() -> ChaoticGameOfDice {
        return ChaoticGameOfDice()
    }
}
