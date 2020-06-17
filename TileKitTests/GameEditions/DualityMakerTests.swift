import TileKit
import XCTest

class DualityMakerTests: XCTestCase {
    func testMake() {
        let actual = GameMaker()
            .use(edition: .duality)
            .makeGame()

        XCTAssertTrue(actual.area.dealer is DefaultDealer<NeutralGameOfDice>)
        XCTAssertTrue(actual.deck.lottery is DualityLottery<NeutralGameOfDice>)
        XCTAssertTrue(actual.area.merger is DualityMerger)
        XCTAssertTrue(actual.deck.mixer is DualityMixer<NeutralGameOfDice>)
    }
    
    func testMakeNonDeterministic() {
        let actual = GameMaker()
            .use(edition: .duality)
            .be(deterministic: false)
            .makeGame()

        XCTAssertTrue(actual.area.dealer is DefaultDealer<ChaoticGameOfDice>)
        XCTAssertTrue(actual.deck.lottery is DualityLottery<ChaoticGameOfDice>)
        XCTAssertTrue(actual.area.merger is DualityMerger)
        XCTAssertTrue(actual.deck.mixer is DualityMixer<ChaoticGameOfDice>)
    }
}
