public struct SimpleLottery<GameOfDice: GameOfDiceProtocol>: Lottery, Codable {
    public let gameOfDice: GameOfDice
    
    public init(gameOfDice: GameOfDice) {
        self.gameOfDice = gameOfDice
    }
    
    private let four = Tile(value: 4, score: 4)
    
    public func draw(maxValue: Int) -> (TileHint, Tile)? {
        var random = gameOfDice.roll()
        return random.next(upperBound: UInt(8)) == 0
            ? (.single(four), four)
            : nil
    }
    
    public func next() -> SimpleLottery<GameOfDice> {
        return SimpleLottery(gameOfDice: gameOfDice.next())
    }
    
    private enum CodingKeys: String, CodingKey {
        case gameOfDice
    }
}
