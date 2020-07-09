import TileKit
import XCTest

class FibonacciMakerTests: XCTestCase {
    func testMake() {
        let actual = GameMaker()
            .use(edition: .fibonacci)
            .makeGame()

        XCTAssertTrue(actual.area.dealer.dealer is DefaultDealer<NeutralGameOfDice>)
        XCTAssertTrue(actual.deck.lottery.lottery is FibonacciLottery<NeutralGameOfDice>)
        XCTAssertTrue(actual.area.merger.merger is FibonacciMerger)
        XCTAssertTrue(actual.deck.mixer.mixer is FibonacciMixer<NeutralGameOfDice>)
    }

    func testMakeNonDeterministic() {
        let actual = GameMaker()
            .use(edition: .fibonacci)
            .be(deterministic: false)
            .makeGame()

        XCTAssertTrue(actual.area.dealer.dealer is DefaultDealer<ChaoticGameOfDice>)
        XCTAssertTrue(actual.deck.lottery.lottery is FibonacciLottery<ChaoticGameOfDice>)
        XCTAssertTrue(actual.area.merger.merger is FibonacciMerger)
        XCTAssertTrue(actual.deck.mixer.mixer is FibonacciMixer<ChaoticGameOfDice>)
    }
}
