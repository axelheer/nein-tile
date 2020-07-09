import TileKit
import XCTest

class InsanityMergerTests: XCTestCase {
    let zero   = Tile(value: 0, score: 0)
    let bonus1 = Tile(value: 0, score: -1138)
    let bonus2 = Tile(value: 0, score: -2276)

    let minusOne   = Tile(value: -1, score: 1)
    let minusTwo   = Tile(value: -2, score: 2)
    let minusThree = Tile(value: -3, score: 3)
    let minusSix   = Tile(value: -6, score: 6)

    let plusOne   = Tile(value: 1, score: 1)
    let plusTwo   = Tile(value: 2, score: 2)
    let plusThree = Tile(value: 3, score: 4)
    let plusSix   = Tile(value: 6, score: 12)

    let zeroMinusTwo = Tile(value: 0, score: 4)
    let zeroPlusTwo = Tile(value: 0, score: 6)

    let max = Tile(value: .max, score: .max)
    let min = Tile(value: .min, score: .min)

    func testCanMerge() {
        let tests = [
            (bonus1, bonus1, true),
            (bonus1, zero, true),
            (bonus1, minusTwo, false),
            (minusTwo, bonus1, false),
            (zero, bonus1, false),
            (zero, zero, false),

            (max, max, false),
            (max, plusTwo, false),
            (plusTwo, max, false),
            (min, min, false),
            (min, minusTwo, false),
            (minusTwo, min, false),

            (minusOne, zero, true),
            (zero, minusOne, false),
            (zero, zero, false),
            (zero, plusOne, false),
            (plusOne, zero, true),

            (minusTwo, minusTwo, false),
            (minusTwo, minusOne, true),
            (minusOne, minusTwo, true),
            (minusOne, minusOne, false),
            (plusOne, plusOne, false),
            (plusOne, plusTwo, true),
            (plusTwo, plusOne, true),
            (plusTwo, plusTwo, false),

            (minusThree, minusThree, true),
            (plusThree, plusThree, true),

            (minusThree, plusThree, true),
            (minusTwo, plusOne, false),
            (minusOne, plusTwo, false),
            (plusOne, minusTwo, false),
            (plusTwo, minusOne, false),
            (plusThree, minusThree, true)
        ]

        let subject = InsanityMerger()

        for (source, target, expected) in tests {
            let actual = subject.canMerge(source, target)
            XCTAssertEqual(actual, expected, "Unexpected value at \(source) => \(target)")
        }
    }

    func testMerge() {
        let tests = [
            (bonus1, bonus2, bonus1),
            (bonus1, bonus1, bonus1),
            (bonus1, zero, bonus1),

            (minusThree, minusThree, minusSix),
            (minusTwo, minusOne, minusThree),
            (minusOne, minusTwo, minusThree),
            (minusOne, zero, minusOne),
            (plusOne, zero, plusOne),
            (plusOne, plusTwo, plusThree),
            (plusTwo, plusOne, plusThree),
            (plusThree, plusThree, plusSix),

            (minusTwo, plusTwo, zeroMinusTwo),
            (plusTwo, minusTwo, zeroPlusTwo)
        ]

        let subject = InsanityMerger()

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
