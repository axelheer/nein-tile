public struct DualityMaker<GameOfDice: GameOfDiceProtocol>: Maker {
    public var gameOfDice: GameOfDice
    
    public init(gameOfDice: GameOfDice) {
        self.gameOfDice = gameOfDice
    }
    
    public mutating func makeDealer() -> Dealer {
        gameOfDice = gameOfDice.next()
        return DefaultDealer(gameOfDice: gameOfDice)
    }
    
    public mutating func makeLottery() -> Lottery {
        gameOfDice = gameOfDice.next()
        return DualityLottery(gameOfDice: gameOfDice)
    }
    
    public mutating func makeMerger() -> Merger {
        gameOfDice = gameOfDice.next()
        return DualityMerger()
    }
    
    public mutating func makeMixer() -> Mixer {
        gameOfDice = gameOfDice.next()
        return DualityMixer(gameOfDice: gameOfDice)
    }
}
