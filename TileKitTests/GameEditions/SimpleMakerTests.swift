import TileKit
import XCTest

class SimpleMakerTests: XCTestCase {
    func testMake() {
        let actual = GameMaker()
            .use(edition: .simple)
            .makeGame()

        XCTAssertTrue(actual.area.dealer is DefaultDealer<NeutralGameOfDice>)
        XCTAssertTrue(actual.deck.lottery is SimpleLottery<NeutralGameOfDice>)
        XCTAssertTrue(actual.area.merger is SimpleMerger)
        XCTAssertTrue(actual.deck.mixer is SimpleMixer<NeutralGameOfDice>)
    }
    
    func testMakeNonDeterministic() {
        let actual = GameMaker()
            .use(edition: .simple)
            .be(deterministic: false)
            .makeGame()

        XCTAssertTrue(actual.area.dealer is DefaultDealer<ChaoticGameOfDice>)
        XCTAssertTrue(actual.deck.lottery is SimpleLottery<ChaoticGameOfDice>)
        XCTAssertTrue(actual.area.merger is SimpleMerger)
        XCTAssertTrue(actual.deck.mixer is SimpleMixer<ChaoticGameOfDice>)
    }
}
