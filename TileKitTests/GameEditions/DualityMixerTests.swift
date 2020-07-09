import TileKit
import XCTest

class DualityMixerTests: XCTestCase {
    private let plusTwo  = Tile(value: 2, score: 2)
    private let minusTwo = Tile(value: -2, score: 2)

    func testMix() {
        let expectedCauseOfLawful = [
            plusTwo,
            plusTwo,
            minusTwo
        ]

        let subject = DualityMixer(gameOfDice: LawfulGameOfDice())

        let actual = Array(subject.mix())

        for index in 0 ..< expectedCauseOfLawful.count {
            XCTAssertEqual(actual[index], expectedCauseOfLawful[index], "Unexpected value at index \(index)")
        }
        XCTAssertEqual(actual.count, expectedCauseOfLawful.count)
    }

    func testNext() {
        let subject = DualityMixer(gameOfDice: LawfulGameOfDice())

        let actual = subject.next()

        var subjectRoll = subject.gameOfDice.roll()
        var actualRoll = actual.gameOfDice.roll()

        XCTAssertNotEqual(actualRoll.next(), subjectRoll.next())
    }
}
