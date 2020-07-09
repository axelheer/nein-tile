import TileKit

func makeTestArea(score: Int = 2) -> (TilesArea, TestMerger) {
    let dealer = DefaultDealer(gameOfDice: LawfulGameOfDice())
    let merger = TestMerger()
    let area = TilesArea(
        tiles: makeTestTiles(score: score),
        dealer: AnyDealer(dealer.next()),
        merger: AnyMerger(merger)
    )
    return (area, merger)
}
