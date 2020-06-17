import TileKit
import XCTest

class ClassicMakerTests: XCTestCase {
    func testMake() {
        let actual = GameMaker()
            .use(edition: .classic)
            .makeGame()

        XCTAssertTrue(actual.area.dealer is DefaultDealer<NeutralGameOfDice>)
        XCTAssertTrue(actual.deck.lottery is ClassicLottery<NeutralGameOfDice>)
        XCTAssertTrue(actual.area.merger is ClassicMerger)
        XCTAssertTrue(actual.deck.mixer is ClassicMixer<NeutralGameOfDice>)
    }
    
    func testMakeNonDeterministic() {
        let actual = GameMaker()
            .use(edition: .classic)
            .be(deterministic: false)
            .makeGame()

        XCTAssertTrue(actual.area.dealer is DefaultDealer<ChaoticGameOfDice>)
        XCTAssertTrue(actual.deck.lottery is ClassicLottery<ChaoticGameOfDice>)
        XCTAssertTrue(actual.area.merger is ClassicMerger)
        XCTAssertTrue(actual.deck.mixer is ClassicMixer<ChaoticGameOfDice>)
    }
}
