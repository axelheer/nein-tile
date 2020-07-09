import TileKit
import XCTest

class DualityMakerTests: XCTestCase {
    func testMake() {
        let actual = GameMaker()
            .use(edition: .duality)
            .makeGame()

        XCTAssertTrue(actual.area.dealer.dealer is DefaultDealer<NeutralGameOfDice>)
        XCTAssertTrue(actual.deck.lottery.lottery is DualityLottery<NeutralGameOfDice>)
        XCTAssertTrue(actual.area.merger.merger is DualityMerger)
        XCTAssertTrue(actual.deck.mixer.mixer is DualityMixer<NeutralGameOfDice>)
    }

    func testMakeNonDeterministic() {
        let actual = GameMaker()
            .use(edition: .duality)
            .be(deterministic: false)
            .makeGame()

        XCTAssertTrue(actual.area.dealer.dealer is DefaultDealer<ChaoticGameOfDice>)
        XCTAssertTrue(actual.deck.lottery.lottery is DualityLottery<ChaoticGameOfDice>)
        XCTAssertTrue(actual.area.merger.merger is DualityMerger)
        XCTAssertTrue(actual.deck.mixer.mixer is DualityMixer<ChaoticGameOfDice>)
    }
}
