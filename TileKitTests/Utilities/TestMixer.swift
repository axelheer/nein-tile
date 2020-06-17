import TileKit

final class TestMixer: Mixer {
    let gameOfDice: LawfulGameOfDice
    
    init(gameOfDice: LawfulGameOfDice) {
        self.gameOfDice = gameOfDice
    }
    
    var onMix: () -> [Tile] = { [.empty] }
    func mix() -> [Tile] {
        return onMix()
    }
    
    func next() -> TestMixer {
        return TestMixer(gameOfDice: gameOfDice)
    }
}
