public struct ChaoticGameOfDice: GameOfDiceProtocol {
    public init() {
    }
    
    public func roll() -> some RandomNumberGenerator {
        return SystemRandomNumberGenerator()
    }
    
    public func next() -> ChaoticGameOfDice {
        return self
    }
}
