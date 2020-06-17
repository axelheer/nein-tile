import TileKit
import XCTest

class GameMakerTests: XCTestCase {
    func testMaker() {
        let actual = GameMaker()
            .use(colCount: 1, rowCount: 2, layCount: 3)
            .makeGame()
        
        XCTAssertNil(actual.last)
        
        XCTAssertEqual(actual.area.tiles.colCount, 1)
        XCTAssertEqual(actual.area.tiles.rowCount, 2)
        XCTAssertEqual(actual.area.tiles.layCount, 3)
    }
    
    func testMakerMove() {
        let subject = GameMaker()
            .be(slippery: false)
            .use(custom: TestMaker())
            .makeGame()
        
        (subject.area.merger as! TestMerger).onCanMerge = { (_, t) in t.value % 4 == 0 }
        
        let actual = subject.move(to: .right)
        
        XCTAssertNotNil(actual.last)
    }
}
