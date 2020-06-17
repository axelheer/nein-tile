import TileKit

func makeTestArea(score: Int = 2) -> (TilesArea, TestMerger) {
    let dealer = DefaultDealer(gameOfDice: LawfulGameOfDice())
    let area = TilesArea(
        tiles: makeTestTiles(score: score),
        dealer: dealer.next(),
        merger: TestMerger()
    )
    return (area, area.merger as! TestMerger)
}
