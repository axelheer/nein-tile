import TileKit

func makeTestDeck() -> (TilesDeck, TestLottery, TestMixer) {
    let gameOfDice = LawfulGameOfDice()
    let deck = TilesDeck(
        mixer: AnyMixer(TestMixer(gameOfDice: gameOfDice.next())),
        lottery: AnyLottery(TestLottery(gameOfDice: gameOfDice.next()))
    )
    return (deck, deck.lottery.lottery as! TestLottery, deck.mixer.mixer as! TestMixer)
}
