public struct UnlimitedLottery<GameOfDice: GameOfDiceProtocol>: Lottery, Codable {
    public let gameOfDice: GameOfDice

    public init(gameOfDice: GameOfDice) {
        self.gameOfDice = gameOfDice
    }

    public func draw(maxValue: Int) -> (TileHint, Tile)? {
        guard maxValue >= 8 else {
            return nil
        }
        var random = gameOfDice.roll()
        let max = Tile(value: maxValue, score: maxValue)
        let mid = Tile(value: maxValue / 2, score: maxValue / 2)
        let min = Tile(value: maxValue / 3, score: maxValue / 3)
        switch random.next(upperBound: UInt(24)) {
        case 0:
            return (.threes(min, mid, max), max)
        case 1:
            return (.threes(min, mid, max), mid)
        case 2:
            return (.threes(min, mid, max), min)
        default:
            return nil
        }
    }

    public func next() -> UnlimitedLottery<GameOfDice> {
        return UnlimitedLottery(gameOfDice: gameOfDice.next())
    }

    private enum CodingKeys: String, CodingKey {
        case gameOfDice
    }
}
