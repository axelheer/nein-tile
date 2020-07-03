import TileKit
import XCTest

class InsanityMakerTests: XCTestCase {
    func testMake() {
        let actual = GameMaker()
            .use(edition: .insanity)
            .makeGame()

        XCTAssertTrue(actual.area.dealer.dealer is DefaultDealer<NeutralGameOfDice>)
        XCTAssertTrue(actual.deck.lottery.lottery is InsanityLottery<NeutralGameOfDice>)
        XCTAssertTrue(actual.area.merger.merger is InsanityMerger)
        XCTAssertTrue(actual.deck.mixer.mixer is InsanityMixer<NeutralGameOfDice>)
    }
    
    func testMakeNonDeterministic() {
        let actual = GameMaker()
            .use(edition: .insanity)
            .be(deterministic: false)
            .makeGame()

        XCTAssertTrue(actual.area.dealer.dealer is DefaultDealer<ChaoticGameOfDice>)
        XCTAssertTrue(actual.deck.lottery.lottery is InsanityLottery<ChaoticGameOfDice>)
        XCTAssertTrue(actual.area.merger.merger is InsanityMerger)
        XCTAssertTrue(actual.deck.mixer.mixer is InsanityMixer<ChaoticGameOfDice>)
    }
}
