import TileKit
import XCTest

class SimpleLotteryTests: XCTestCase {
    let four = Tile(value: 4, score: 4)

    func testDraw() {
        let expectedCauseOfLawful: [Int: (TileHint, Tile)] = [
            6: (.single(four), four),
            11: (.single(four), four),
            17: (.single(four), four),
            22: (.single(four), four)
        ]

        var subject = SimpleLottery(gameOfDice: LawfulGameOfDice())

        for iteration in 0 ..< 32 {
            let actual = subject.draw(maxValue: 0)
            if let (expectedHint, expectedTile) = expectedCauseOfLawful[iteration] {
                if let (actualHint, actualTile) = actual {
                    XCTAssertEqual(actualHint, expectedHint, "Unexpected value at iteration \(iteration)")
                    XCTAssertEqual(actualTile, expectedTile, "Unexpected value at iteration \(iteration)")
                }
                XCTAssertNotNil(actual, "Unexpected value at iteration \(iteration)")
            } else {
                XCTAssertNil(actual, "Unexpected value at iteration \(iteration)")
            }
            subject = subject.next()
        }
    }

    func testNext() {
        let subject = SimpleLottery(gameOfDice: LawfulGameOfDice())

        let actual = subject.next()

        var subjectRoll = subject.gameOfDice.roll()
        var actualRoll = actual.gameOfDice.roll()

        XCTAssertNotEqual(actualRoll.next(), subjectRoll.next())
    }
}
