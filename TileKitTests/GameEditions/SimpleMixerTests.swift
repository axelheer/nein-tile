import TileKit
import XCTest

class SimpleMixerTests: XCTestCase {
    let two = Tile(value: 2, score: 0)

    func testMix() {
        let expectedCauseOfLawful = [ two ]

        let subject = SimpleMixer(gameOfDice: LawfulGameOfDice())

        let actual = Array(subject.mix())

        for index in 0 ..< expectedCauseOfLawful.count {
            XCTAssertEqual(actual[index], expectedCauseOfLawful[index], "Unexpected value at index \(index)")
        }
        XCTAssertEqual(actual.count, expectedCauseOfLawful.count)
    }

    func testNext() {
        let subject = SimpleMixer(gameOfDice: LawfulGameOfDice())

        let actual = subject.next()

        var subjectRoll = subject.gameOfDice.roll()
        var actualRoll = actual.gameOfDice.roll()

        XCTAssertNotEqual(actualRoll.next(), subjectRoll.next())
    }
}
