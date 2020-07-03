import TileKit
import XCTest

class TilesDeckTest: XCTestCase {
    func testMix() {
        let (subject, _, mixer) = makeTestDeck()
        mixer.onMix = { [Tile(value: 1, score: 1)] }
        
        let actual = subject.next(maxValue: 0)
        
        XCTAssertEqual(actual.tile, Tile(value: 1, score: 1))
        XCTAssertEqual(actual.mixer.mix(), [.empty])
    }
    
    func testMixNext() {
        let (subject, _, mixer) = makeTestDeck()
        mixer.onMix = { [Tile(value: 2, score: 2), Tile(value: 1, score: 1)] }
        
        let actual = subject.next(maxValue: 0).next(maxValue: 0)
        
        XCTAssertEqual(actual.tile, Tile(value: 2, score: 2))
        XCTAssertEqual(actual.mixer.mix(), [.empty])
    }
    
    func testDraw() {
        let (subject, lottery, _) = makeTestDeck()
        lottery.onDraw = { _ in (.single(.empty), Tile(value: 3, score: 3)) }
        
        let actual = subject.next(maxValue: 0)
        
        XCTAssertEqual(actual.tile, Tile(value: 3, score: 3))
        XCTAssertNil(actual.lottery.draw(maxValue: 0))
    }
    
    func testDrawNext() {
        let (subject, lottery, _) = makeTestDeck()
        lottery.onDraw = { _ in (.single(.empty), Tile(value: 3, score: 3)) }
        
        let actual = subject.next(maxValue: 0).next(maxValue: 0)
        
        XCTAssertEqual(actual.tile, .empty)
        XCTAssertNil(actual.lottery.draw(maxValue: 0))
    }
}
