import TileKit

func makeTestDeck() -> (TilesDeck, TestLottery, TestMixer) {
    let gameOfDice = LawfulGameOfDice()
    let deck = TilesDeck(
        mixer: TestMixer(gameOfDice: gameOfDice.next()),
        lottery: TestLottery(gameOfDice: gameOfDice.next())
    )
    return (deck, deck.lottery as! TestLottery, deck.mixer as! TestMixer)
}
