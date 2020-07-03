public struct FibonacciMixer<GameOfDice: GameOfDiceProtocol>: Mixer, Codable {
    public let gameOfDice: GameOfDice
    
    public init(gameOfDice: GameOfDice) {
        self.gameOfDice = gameOfDice
    }
    
    private let one   = Tile(value: 1, score: 0)
    
    public func mix() -> [Tile] {
        return [one]
    }
    
    public func next() -> FibonacciMixer<GameOfDice> {
        return FibonacciMixer(gameOfDice: gameOfDice.next())
    }
    
    private enum CodingKeys: String, CodingKey {
        case gameOfDice
    }
}
