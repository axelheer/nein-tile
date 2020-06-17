public final class InsanityMaker<GameOfDice: GameOfDiceProtocol>: Maker {
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
        return InsanityLottery(gameOfDice: gameOfDice)
    }
    
    public func makeMerger() -> Merger {
        gameOfDice = gameOfDice.next()
        return InsanityMerger()
    }
    
    public func makeMixer() -> Mixer {
        gameOfDice = gameOfDice.next()
        return InsanityMixer(gameOfDice: gameOfDice)
    }
}
