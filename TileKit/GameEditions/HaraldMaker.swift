public struct HaraldMaker<GameOfDice: GameOfDiceProtocol>: Maker {
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
        return HaraldLottery(gameOfDice: gameOfDice)
    }

    public mutating func makeMerger() -> Merger {
        gameOfDice = gameOfDice.next()
        return HaraldMerger()
    }

    public mutating func makeMixer() -> Mixer {
        gameOfDice = gameOfDice.next()
        return HaraldMixer(gameOfDice: gameOfDice)
    }
}
