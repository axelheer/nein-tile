public struct DualityMixer<GameOfDice: GameOfDiceProtocol>: Mixer {
    public let gameOfDice: GameOfDice
    
    public init(gameOfDice: GameOfDice) {
        self.gameOfDice = gameOfDice
    }
    
    private let plusTwo  = Tile(value: 2,  score: 2)
    private let minusTwo = Tile(value: -2, score: 2)
    
    public func mix() -> [Tile] {
        var random = gameOfDice.roll()
        let result = [
            plusTwo,
            plusTwo,
            minusTwo
        ]
        return result.shuffled(using: &random)
    }
    
    public func next() -> DualityMixer<GameOfDice> {
        return DualityMixer(gameOfDice: gameOfDice.next())
    }
}
