import TileKit
import XCTest

class SimpleMakerTests: XCTestCase {
    func testMake() {
        let actual = GameMaker()
            .use(edition: .simple)
            .makeGame()

        XCTAssertTrue(actual.area.dealer.dealer is DefaultDealer<NeutralGameOfDice>)
        XCTAssertTrue(actual.deck.lottery.lottery is SimpleLottery<NeutralGameOfDice>)
        XCTAssertTrue(actual.area.merger.merger is SimpleMerger)
        XCTAssertTrue(actual.deck.mixer.mixer is SimpleMixer<NeutralGameOfDice>)
    }
    
    func testMakeNonDeterministic() {
        let actual = GameMaker()
            .use(edition: .simple)
            .be(deterministic: false)
            .makeGame()

        XCTAssertTrue(actual.area.dealer.dealer is DefaultDealer<ChaoticGameOfDice>)
        XCTAssertTrue(actual.deck.lottery.lottery is SimpleLottery<ChaoticGameOfDice>)
        XCTAssertTrue(actual.area.merger.merger is SimpleMerger)
        XCTAssertTrue(actual.deck.mixer.mixer is SimpleMixer<ChaoticGameOfDice>)
    }
}
