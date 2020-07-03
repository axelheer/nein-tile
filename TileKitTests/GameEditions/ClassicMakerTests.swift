import TileKit
import XCTest

class ClassicMakerTests: XCTestCase {
    func testMake() {
        let actual = GameMaker()
            .use(edition: .classic)
            .makeGame()

        XCTAssertTrue(actual.area.dealer.dealer is DefaultDealer<NeutralGameOfDice>)
        XCTAssertTrue(actual.deck.lottery.lottery is ClassicLottery<NeutralGameOfDice>)
        XCTAssertTrue(actual.area.merger.merger is ClassicMerger)
        XCTAssertTrue(actual.deck.mixer.mixer is ClassicMixer<NeutralGameOfDice>)
    }
    
    func testMakeNonDeterministic() {
        let actual = GameMaker()
            .use(edition: .classic)
            .be(deterministic: false)
            .makeGame()

        XCTAssertTrue(actual.area.dealer.dealer is DefaultDealer<ChaoticGameOfDice>)
        XCTAssertTrue(actual.deck.lottery.lottery is ClassicLottery<ChaoticGameOfDice>)
        XCTAssertTrue(actual.area.merger.merger is ClassicMerger)
        XCTAssertTrue(actual.deck.mixer.mixer is ClassicMixer<ChaoticGameOfDice>)
    }
}
