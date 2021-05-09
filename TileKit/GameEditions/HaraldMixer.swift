public struct HaraldMixer<GameOfDice: GameOfDiceProtocol>: Mixer, Codable {
    public let gameOfDice: GameOfDice

    public init(gameOfDice: GameOfDice) {
        self.gameOfDice = gameOfDice
    }

    public func mix() -> [Tile] {
        return [Tile(value: 131072, score: 2097152)]
    }

    public func next() -> HaraldMixer<GameOfDice> {
        return HaraldMixer(gameOfDice: gameOfDice.next())
    }

    private enum CodingKeys: String, CodingKey {
        case gameOfDice
    }
}
