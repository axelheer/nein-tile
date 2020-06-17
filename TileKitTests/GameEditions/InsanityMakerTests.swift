import TileKit
import XCTest

class InsanityMakerTests: XCTestCase {
    func testMake() {
        let actual = GameMaker()
            .use(edition: .insanity)
            .makeGame()

        XCTAssertTrue(actual.area.dealer is DefaultDealer<NeutralGameOfDice>)
        XCTAssertTrue(actual.deck.lottery is InsanityLottery<NeutralGameOfDice>)
        XCTAssertTrue(actual.area.merger is InsanityMerger)
        XCTAssertTrue(actual.deck.mixer is InsanityMixer<NeutralGameOfDice>)
    }
    
    func testMakeNonDeterministic() {
        let actual = GameMaker()
            .use(edition: .insanity)
            .be(deterministic: false)
            .makeGame()

        XCTAssertTrue(actual.area.dealer is DefaultDealer<ChaoticGameOfDice>)
        XCTAssertTrue(actual.deck.lottery is InsanityLottery<ChaoticGameOfDice>)
        XCTAssertTrue(actual.area.merger is InsanityMerger)
        XCTAssertTrue(actual.deck.mixer is InsanityMixer<ChaoticGameOfDice>)
    }
}
