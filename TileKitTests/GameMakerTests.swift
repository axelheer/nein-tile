import TileKit
import XCTest

class GameMakerTests: XCTestCase {
    func testMaker() {
        let actual = GameMaker()
            .be(slippery: false)
            .be(apprentice: false)
            .be(deterministic: false)
            .use(colCount: 1, rowCount: 2, layCount: 3)
            .makeGame()

        XCTAssertEqual(actual.area.tiles.colCount, 1)
        XCTAssertEqual(actual.area.tiles.rowCount, 2)
        XCTAssertEqual(actual.area.tiles.layCount, 3)

        XCTAssertFalse(actual.maker.slippery)
        XCTAssertFalse(actual.maker.apprentice)
        XCTAssertFalse(actual.maker.deterministic)
    }
}
