import TileKit

// swiftlint:disable large_tuple

func makeTestDeck() -> (TilesDeck, TestLottery, TestMixer) {
    let gameOfDice = LawfulGameOfDice()
    let lottery = TestLottery(gameOfDice: gameOfDice.next())
    let mixer = TestMixer(gameOfDice: gameOfDice.next())
    let deck = TilesDeck(
        mixer: AnyMixer(mixer),
        lottery: AnyLottery(lottery)
    )
    return (deck, lottery, mixer)
}
