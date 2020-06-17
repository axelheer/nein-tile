import TileKit
import XCTest

class TilesAreaTests: XCTestCase {
    func testCanMove() {
        let (subject, merger) = makeTestArea()
        merger.onCanMerge = { (_, _) in true }
        
        let actual = subject.canMove(to: .right)
        
        XCTAssertTrue(actual)
    }
    
    func testNotCanMove() {
        let (subject, merger) = makeTestArea()
        merger.onCanMerge = { (_, _) in false }
        
        let actual = subject.canMove(to: .right)
        
        XCTAssertFalse(actual)
    }
    
    func testMove() {
        let (subject, merger) = makeTestArea()
        merger.onCanMerge = { (_, t) in t.value % 4 == 0 }
        merger.onMerge = { (s, t) in Tile(value: s.value + t.value, score: s.score + t.score) }
        
        let actual = subject.move(to: .right, slippery: false, nextTile: .empty)
        
        for lay in 0 ..< 4 {
            for row in 0 ..< 4 {
                XCTAssertEqual(actual.tiles[0, row, lay], .empty,
                               "Unexpected value at lay \(lay), row \(row)"
                )
                XCTAssertEqual(actual.tiles[1, row, lay], Tile(value: (row * 4) + (lay * 16) + 1, score: 2),
                               "Unexpected value at lay \(lay), row \(row)"
                )
                XCTAssertEqual(actual.tiles[2, row, lay], Tile(value: (row * 4) + (lay * 16) + 2, score: 2),
                               "Unexpected value at lay \(lay), row \(row)"
                )
                XCTAssertEqual(actual.tiles[3, row, lay], Tile(value: ((row * 4) + (lay * 16) + 3) * 2 + 1, score: 4),
                               "Unexpected value at lay \(lay), row \(row)"
                )
            }
        }
    }
    
    func testMoveMarkers() {
        let (subject, merger) = makeTestArea()
        merger.onCanMerge = { (_, t) in t.value % 4 == 0 }
        
        let nextCauseOfLawful = [ (1, 0), (2, 1), (3, 0), (3, 2) ]
        
        let actual = subject.move(to: .right, slippery: false, nextTile: Tile(value: 0, score: 2))
        
        for lay in 0 ..< 4 {
            for row in 0 ..< 4 {
                if nextCauseOfLawful.contains(where: { $0.0 == lay && $0.1 == row }) {
                    XCTAssertEqual(actual.tiles[0, row, lay], Tile(value: 0, score: 2),
                                   "Unexpected value at lay \(lay), row \(row)")
                } else {
                    XCTAssertEqual(actual.tiles[0, row, lay], .empty,
                                   "Unexpected value at lay \(lay), row \(row)")
                }
            }
        }
    }
    
    func testMoveSlippery() {
        let (subject, merger) = makeTestArea()
        merger.onCanMerge = { (source, _) in source != .empty }
        merger.onMerge = { (s, t) in Tile(value: s.value + t.value, score: s.score + t.score) }
        
        let actual = subject.move(to: .right, slippery: true, nextTile: .empty)
        
        for lay in 0 ..< 4 {
            for row in 0 ..< 4 {
                XCTAssertEqual(actual.tiles[0, row, lay], .empty,
                               "Unexpected value at lay \(lay), row \(row)"
                )
                XCTAssertEqual(actual.tiles[1, row, lay], .empty,
                               "Unexpected value at lay \(lay), row \(row)"
                )
                XCTAssertEqual(actual.tiles[2, row, lay], Tile(value: ((row * 4) + (lay * 16) + 1) * 2 + 1, score: 4),
                               "Unexpected value at lay \(lay), row \(row)"
                )
                XCTAssertEqual(actual.tiles[3, row, lay], Tile(value: ((row * 4) + (lay * 16) + 3) * 2 + 1, score: 4),
                               "Unexpected value at lay \(lay), row \(row)"
                )
            }
        }
    }
    
    func testMoveSlipperyMarkers() {
        let (subject, merger) = makeTestArea()
        merger.onCanMerge = { (source, _) in source != .empty }
        
        let nextCauseOfLawful = [ (1, 1, 0), (1, 1, 1), (2, 3, 0), (2, 3, 1) ]
        
        let actual = subject.move(to: .right, slippery: true, nextTile: Tile(value: 0, score: 2))
        
        for lay in 0 ..< 4 {
            for row in 0 ..< 4 {
                for col in 0 ..< 2 {
                    if nextCauseOfLawful.contains(where: { $0.0 == lay && $0.1 == row && $0.2 == col }) {
                        XCTAssertEqual(actual.tiles[0, row, lay], Tile(value: 0, score: 2),
                                       "Unexpected value at lay \(lay), row \(row), col \(col)")
                    } else {
                        XCTAssertEqual(actual.tiles[0, row, lay], .empty,
                                       "Unexpected value at lay \(lay), row \(row), col \(col)")
                    }
                }
            }
        }
    }
    
    func testMoveNext() {
        let (subject, merger) = makeTestArea()
        merger.onCanMerge = { (_, _) in true }
        
        let actual = subject.move(to: .right, slippery: false, nextTile: .empty)
        
        XCTAssertNotEqual(actual.dealer.part(actual.tiles.indices), subject.dealer.part(actual.tiles.indices))
    }
    
    func testMinValue() {
        let (subject, _) = makeTestArea()
        
        XCTAssertEqual(subject.tiles.minValue, 1)
    }
    
    func testMaxValue() {
        let (subject, _) = makeTestArea()
        
        XCTAssertEqual(subject.tiles.maxValue, 64)
    }
    
    func testTotalScore() {
        let (subject, _) = makeTestArea()
        
        XCTAssertEqual(subject.tiles.totalScore, 128)
    }
    
    func testOverflow() {
        let (subject, _) = makeTestArea(score: .max)
        
        XCTAssertEqual(subject.tiles.totalScore, Int.max)
    }
}
