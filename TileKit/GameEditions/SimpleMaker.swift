public final class SimpleMaker<GameOfDice: GameOfDiceProtocol>: Maker {
    public var gameOfDice: GameOfDice
    
    public init(gameOfDice: GameOfDice) {
        self.gameOfDice = gameOfDice
    }
    
    public func makeDealer() -> Dealer {
        gameOfDice = gameOfDice.next()
        return DefaultDealer(gameOfDice: gameOfDice)
    }
    
    public func makeLottery() -> Lottery {
        gameOfDice = gameOfDice.next()
        return SimpleLottery(gameOfDice: gameOfDice)
    }
    
    public func makeMerger() -> Merger {
        gameOfDice = gameOfDice.next()
        return SimpleMerger()
    }
    
    public func makeMixer() -> Mixer {
        gameOfDice = gameOfDice.next()
        return SimpleMixer(gameOfDice: gameOfDice)
    }
}
