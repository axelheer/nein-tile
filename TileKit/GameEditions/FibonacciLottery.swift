public struct FibonacciLottery<GameOfDice: GameOfDiceProtocol>: Lottery, Codable {
    public let gameOfDice: GameOfDice

    public init(gameOfDice: GameOfDice) {
        self.gameOfDice = gameOfDice
    }

    private let two   = Tile(value: 2, score: 0)
    private let three = Tile(value: 3, score: 3)

    public func draw(maxValue: Int) -> (TileHint, Tile)? {
        var random = gameOfDice.roll()
        switch random.next(upperBound: UInt(27)) {
        case (0 ..< 6):
            return (.either(two, three), two)
        case (6 ..< 9):
            return (.either(two, three), three)
        default:
            return nil
        }
    }

    public func next() -> FibonacciLottery<GameOfDice> {
        return FibonacciLottery(gameOfDice: gameOfDice.next())
    }

    private enum CodingKeys: String, CodingKey {
        case gameOfDice
    }
}
