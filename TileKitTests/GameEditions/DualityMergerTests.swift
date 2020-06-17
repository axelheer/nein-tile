import TileKit
import XCTest

class DualityMergerTests: XCTestCase {
    let zero   = Tile(value: 0, score: 0)
    let bonus1 = Tile(value: 0, score: 1138)
    let bonus2 = Tile(value: 0, score: 2276)
    
    let minusTwo   = Tile(value: -2, score: 2)
    let minusFour  = Tile(value: -4, score: 8)
    let minusEight = Tile(value: -8, score: 24)
    
    let plusTwo   = Tile(value: 2, score: 2)
    let plusFour  = Tile(value: 4, score: 8)
    let plusEight = Tile(value: 8, score: 24)
    
    let max = Tile(value: .max, score: .max)
    let min = Tile(value: .min, score: .min)
    
    let zeroTwo = Tile(value: 0, score: 4)
    
    func testCanMerge() {
        let tests = [
            (bonus1, bonus1,   true),
            (bonus1, zero,     true),
            (bonus1, minusTwo, false),
            (minusTwo, bonus1, false),
            (zero,   bonus1,   false),
            (zero,   zero,     false),
            
            (max,      max,      false),
            (max,      plusTwo,  false),
            (plusTwo,  max,      false),
            (min,      min,      false),
            (min,      minusTwo, false),
            (minusTwo, min,      false),
            
            (minusTwo, zero,     true),
            (zero,     minusTwo, false),
            (zero,     zero,     false),
            (zero,     plusTwo,  false),
            (plusTwo,  zero,     true),
            
            (minusFour, minusTwo,  false),
            (minusTwo,  minusFour, false),
            (minusTwo,  minusTwo,  true),
            (plusTwo,   plusTwo,   true),
            (plusTwo,   plusFour,  false),
            (plusFour,  plusTwo,   false),
            
            (minusFour, plusTwo,  false),
            (minusTwo,  plusTwo,  true),
            (plusTwo,   minusTwo, true),
            (plusFour,  minusTwo, false)
        ]
        
        let subject = DualityMerger()
        
        for (source, target, expected) in tests {
            let actual = subject.canMerge(source, target)
            XCTAssertEqual(actual, expected, "Unexpected value at \(source) => \(target)")
        }
    }
    
    func testMerge() {
        let tests = [
            (bonus1, bonus2, bonus2),
            (bonus1, bonus1, bonus1),
            (bonus1, zero,   bonus1),
            
            (minusFour, minusFour, minusEight),
            (minusTwo,  minusTwo,  minusFour),
            (minusTwo,  zero,      minusTwo),
            (plusTwo,   zero,      plusTwo),
            (plusTwo,   plusTwo,   plusFour),
            (plusFour,  plusFour,  plusEight),
            
            (minusTwo,  plusTwo,  zeroTwo),
            (plusTwo,   minusTwo, zeroTwo)
        ]
        
        let subject = DualityMerger()
        
        for (source, target, expected) in tests {
            let actual = subject.merge(source, target)
            XCTAssertEqual(actual, expected, "Unexpected value at \(source) => \(target)")
        }
    }
    
    func testOverflow() {
        let big = Tile(value: 1 << (.bitWidth - 1), score: .min)

        let subject = ClassicMerger()
        
        let actual = subject.merge(big, big)

        XCTAssertEqual(actual, min)
    }
}
