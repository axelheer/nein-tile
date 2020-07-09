public struct InsanityLottery<GameOfDice: GameOfDiceProtocol>: Lottery, Codable {
    public let gameOfDice: GameOfDice

    public init(gameOfDice: GameOfDice) {
        self.gameOfDice = gameOfDice
    }

    public func draw(maxValue: Int) -> (TileHint, Tile)? {
        var random = gameOfDice.roll()
        let zero = Tile(value: 0, score: -maxValue)
        return random.next(upperBound: UInt(16)) == 0
            ? (.single(zero), zero)
            : nil
    }

    public func next() -> InsanityLottery<GameOfDice> {
        return InsanityLottery(gameOfDice: gameOfDice.next())
    }

    private enum CodingKeys: String, CodingKey {
        case gameOfDice
    }
}
