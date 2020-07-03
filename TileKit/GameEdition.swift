public enum GameEdition: String, CaseIterable, Codable {
    case simple
    case classic
    case duality
    case insanity
    case fibonacci
    
    public func maker(deterministic: Bool) -> Maker {
        return deterministic
            ? maker(gameOfDice: NeutralGameOfDice())
            : maker(gameOfDice: ChaoticGameOfDice())
    }
    
    public func maker<GameOfDice: GameOfDiceProtocol>(gameOfDice: GameOfDice) -> Maker {
        switch self {
        case .simple:
            return SimpleMaker(gameOfDice: gameOfDice)
        case .classic:
            return ClassicMaker(gameOfDice: gameOfDice)
        case .duality:
            return DualityMaker(gameOfDice: gameOfDice)
        case .insanity:
            return InsanityMaker(gameOfDice: gameOfDice)
        case .fibonacci:
            return FibonacciMaker(gameOfDice: gameOfDice)
        }
    }
}
