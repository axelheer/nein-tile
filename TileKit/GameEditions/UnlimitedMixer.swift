public struct UnlimitedMixer<GameOfDice: GameOfDiceProtocol>: Mixer, Codable {
    public let gameOfDice: GameOfDice

    public init(gameOfDice: GameOfDice) {
        self.gameOfDice = gameOfDice
    }

    private let one   = Tile(value: 1, score: 1)
    private let two   = Tile(value: 2, score: 2)
    private let three = Tile(value: 3, score: 3)

    public func mix() -> [Tile] {
        var random = gameOfDice.roll()
        let result = [
            one, two, three,
            one, two, three,
            one, two, three,
            one, two, three
        ]
        return result.shuffled(using: &random)
    }

    public func next() -> UnlimitedMixer<GameOfDice> {
        return UnlimitedMixer(gameOfDice: gameOfDice.next())
    }

    private enum CodingKeys: String, CodingKey {
        case gameOfDice
    }
}
