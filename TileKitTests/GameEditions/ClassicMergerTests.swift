import TileKit
import XCTest

class ClassicMergerTests: XCTestCase {
    let zero  = Tile(value: 0, score: 0)
    let one   = Tile(value: 1, score: 0)
    let two   = Tile(value: 2, score: 0)
    let three = Tile(value: 3, score: 3)
    let six   = Tile(value: 6, score: 9)
    
    let max   = Tile(value: .max, score: .max)
    
    func testCanMerge() {
        let tests = [
            (zero, zero, false),
            (zero, one,  false),
            (one,  zero, true),
            
            (max, max, false),
            (max, one, false),
            (one, max, false),
            
            (one, one, false),
            (one, two, true),
            (two, one, true),
            (two, two, false),
            
            (three, three, true)
        ]
        
        let subject = ClassicMerger()
        
        for (source, target, expected) in tests {
            let actual = subject.canMerge(source, target)
            XCTAssertEqual(actual, expected, "Unexpected value at \(source) => \(target)")
        }
    }
    
    func testMerge() {
        let tests = [
            (one,   zero,  one),
            (one,   two,   three),
            (two,   one,   three),
            (three, three, six)
        ]
        
        let subject = ClassicMerger()
        
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
