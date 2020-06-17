import TileKit
import XCTest

class FibonacciMakerTests: XCTestCase {
    func testMake() {
        let actual = GameMaker()
            .use(edition: .fibonacci)
            .makeGame()

        XCTAssertTrue(actual.area.dealer is DefaultDealer<NeutralGameOfDice>)
        XCTAssertTrue(actual.deck.lottery is FibonacciLottery<NeutralGameOfDice>)
        XCTAssertTrue(actual.area.merger is FibonacciMerger)
        XCTAssertTrue(actual.deck.mixer is FibonacciMixer<NeutralGameOfDice>)
    }
    
    func testMakeNonDeterministic() {
        let actual = GameMaker()
            .use(edition: .fibonacci)
            .be(deterministic: false)
            .makeGame()

        XCTAssertTrue(actual.area.dealer is DefaultDealer<ChaoticGameOfDice>)
        XCTAssertTrue(actual.deck.lottery is FibonacciLottery<ChaoticGameOfDice>)
        XCTAssertTrue(actual.area.merger is FibonacciMerger)
        XCTAssertTrue(actual.deck.mixer is FibonacciMixer<ChaoticGameOfDice>)
    }
}
