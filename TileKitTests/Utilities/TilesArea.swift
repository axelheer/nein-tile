import TileKit

func makeTestArea(score: Int = 2) -> (TilesArea, TestMerger) {
    let dealer = DefaultDealer(gameOfDice: LawfulGameOfDice())
    let area = TilesArea(
        tiles: makeTestTiles(score: score),
        dealer: AnyDealer(dealer.next()),
        merger: AnyMerger(TestMerger())
    )
    return (area, area.merger.merger as! TestMerger)
}
