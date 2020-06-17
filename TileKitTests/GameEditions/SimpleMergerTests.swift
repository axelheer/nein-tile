import TileKit
import XCTest

class SimpleMergerTests: XCTestCase {
    let zero  = Tile(value: 0, score: 0)
    let two   = Tile(value: 2, score: 0)
    let four  = Tile(value: 4, score: 4)
    let eight = Tile(value: 8, score: 16)
    
    let max   = Tile(value: .max, score: .max)
    
    func testCanMerge() {
        let tests = [
            (zero, zero, false),
            (zero, two,  false),
            (two,  zero, true),
            
            (max, max, false),
            (max, two, false),
            (two, max, false),
            
            (two,  two,  true),
            (two,  four, false),
            (four, two,  false)
        ]
        
        let subject = SimpleMerger()
        
        for (source, target, expected) in tests {
            let actual = subject.canMerge(source, target)
            XCTAssertEqual(actual, expected, "Unexpected value at \(source) => \(target)")
        }
    }
    
    func testMerge() {
        let tests = [
            (two,  zero, two),
            (two,  two,  four),
            (four, four, eight)
        ]
        
        let subject = SimpleMerger()
        
        for (source, target, expected) in tests {
            let actual = subject.merge(source, target)
            XCTAssertEqual(actual, expected, "Unexpected value at \(source) => \(target)")
        }
    }
    
    func testOverflow() {
        let big = Tile(value: 1 << (.bitWidth - 2), score: .max)

        let subject = ClassicMerger()
        
        let actual = subject.merge(big, big)

        XCTAssertEqual(actual, max)
    }
}
