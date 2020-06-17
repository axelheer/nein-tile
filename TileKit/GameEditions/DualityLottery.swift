public struct DualityLottery<GameOfDice: GameOfDiceProtocol>: Lottery {
    public let gameOfDice: GameOfDice
    
    public init(gameOfDice: GameOfDice) {
        self.gameOfDice = gameOfDice
    }
    
    public func draw(maxValue: Int) -> (TileHint, Tile)? {
        var random = gameOfDice.roll()
        let zero = Tile(value: 0, score: maxValue)
        return random.next(upperBound: UInt(16)) == 0
            ? (.single(zero), zero)
            : nil
    }
    
    public func next() -> DualityLottery<GameOfDice> {
        return DualityLottery(gameOfDice: gameOfDice.next())
    }
}
