public struct DefaultDealer<GameOfDice: GameOfDiceProtocol>: Dealer {
    public let gameOfDice: GameOfDice
    
    public let ratio: Int
    
    public init(gameOfDice: GameOfDice) {
        self.init(gameOfDice: gameOfDice, ratio: 2)
    }
    
    private init(gameOfDice: GameOfDice, ratio: Int) {
        self.gameOfDice = gameOfDice
        self.ratio = ratio
    }
    
    public func part(_ indices: [TileIndex]) -> [TileIndex] {
        var random = gameOfDice.roll()
        return indices
            .shuffled(using: &random)
            .dropLast(indices.count - max(1, indices.count / ratio))
    }
    
    public func next() -> DefaultDealer<GameOfDice> {
        return DefaultDealer(gameOfDice: gameOfDice.next(), ratio: 4)
    }
}
