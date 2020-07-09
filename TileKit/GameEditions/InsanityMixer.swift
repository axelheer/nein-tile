public struct InsanityMixer<GameOfDice: GameOfDiceProtocol>: Mixer, Codable {
    public let gameOfDice: GameOfDice

    public init(gameOfDice: GameOfDice) {
        self.gameOfDice = gameOfDice
    }

    private let minusOne   = Tile(value: -1, score: 1)
    private let minusTwo   = Tile(value: -2, score: 2)
    private let minusThree = Tile(value: -3, score: 3)

    private let plusOne   = Tile(value: 1, score: 1)
    private let plusTwo   = Tile(value: 2, score: 2)
    private let plusThree = Tile(value: 3, score: 3)

    public func mix() -> [Tile] {
        var random = gameOfDice.roll()
        let result = [
            minusOne, minusTwo, minusThree,
            minusOne, minusTwo, minusThree,

            plusOne, plusTwo, plusThree,
            plusOne, plusTwo, plusThree,
            plusOne, plusTwo, plusThree,
            plusOne, plusTwo, plusThree
        ]
        return result.shuffled(using: &random)
    }

    public func next() -> InsanityMixer<GameOfDice> {
        return InsanityMixer(gameOfDice: gameOfDice.next())
    }

    private enum CodingKeys: String, CodingKey {
        case gameOfDice
    }
}
