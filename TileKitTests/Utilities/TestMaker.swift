import TileKit

final class TestMaker: Maker {
    let gameOfDice = LawfulGameOfDice()
    
    func makeDealer() -> Dealer {
        return DefaultDealer(gameOfDice: gameOfDice)
    }
    
    func makeLottery() -> Lottery {
        return TestLottery(gameOfDice: gameOfDice)
    }
    
    func makeMerger() -> Merger {
        return TestMerger()
    }
    
    func makeMixer() -> Mixer {
        return TestMixer(gameOfDice: gameOfDice)
    }
}
