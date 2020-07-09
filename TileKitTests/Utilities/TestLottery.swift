import TileKit

final class TestLottery: Lottery {
    let gameOfDice: LawfulGameOfDice

    init(gameOfDice: LawfulGameOfDice) {
        self.gameOfDice = gameOfDice
    }

    var onDraw: (Int) -> (TileHint, Tile)? = { _ in nil }
    func draw(maxValue: Int) -> (TileHint, Tile)? {
        return onDraw(maxValue)
    }

    func next() -> TestLottery {
        return TestLottery(gameOfDice: gameOfDice.next())
    }
}
