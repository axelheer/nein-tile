import TileKit

func makeTestDeck(mixer: TestMixer) -> (TilesDeck, TestLottery) {
    let gameOfDice = LawfulGameOfDice()
    let lottery = TestLottery(gameOfDice: gameOfDice.next())
    let deck = TilesDeck(
        mixer: AnyMixer(mixer),
        lottery: AnyLottery(lottery)
    )
    return (deck, lottery)
}
