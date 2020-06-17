public struct SimpleMixer<GameOfDice: GameOfDiceProtocol>: Mixer {
    public let gameOfDice: GameOfDice
    
    public init(gameOfDice: GameOfDice) {
        self.gameOfDice = gameOfDice
    }
    
    private let two = Tile(value: 2, score: 0)
    
    public func mix() -> [Tile] {
        return [two]
    }
    
    public func next() -> SimpleMixer<GameOfDice> {
        return SimpleMixer(gameOfDice: gameOfDice.next())
    }
}
