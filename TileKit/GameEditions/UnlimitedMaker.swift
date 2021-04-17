public struct UnlimitedMaker<GameOfDice: GameOfDiceProtocol>: Maker {
    public var gameOfDice: GameOfDice

    public init(gameOfDice: GameOfDice) {
        self.gameOfDice = gameOfDice
    }

    public mutating func makeDealer() -> Dealer {
        gameOfDice = gameOfDice.next()
        return UnlimitedDealer(gameOfDice: gameOfDice)
    }

    public mutating func makeLottery() -> Lottery {
        gameOfDice = gameOfDice.next()
        return UnlimitedLottery(gameOfDice: gameOfDice)
    }

    public mutating func makeMerger() -> Merger {
        gameOfDice = gameOfDice.next()
        return UnlimitedMerger()
    }

    public mutating func makeMixer() -> Mixer {
        gameOfDice = gameOfDice.next()
        return UnlimitedMixer(gameOfDice: gameOfDice)
    }
}
