import TileKit
import XCTest

class InsanityMixerTests: XCTestCase {
    private let minusOne   = Tile(value: -1, score: 1)
    private let minusTwo   = Tile(value: -2, score: 2)
    private let minusThree = Tile(value: -3, score: 3)

    private let plusOne   = Tile(value: 1, score: 1)
    private let plusTwo   = Tile(value: 2, score: 2)
    private let plusThree = Tile(value: 3, score: 3)

    func testMix() {
        let expectedCauseOfLawful = [
            minusThree, plusTwo, plusOne,
            plusThree, minusOne, plusTwo,
            plusOne, plusOne, plusOne,
            minusThree, minusOne, plusThree,
            plusTwo, plusThree, minusTwo,
            plusThree, minusTwo, plusTwo
        ]

        let subject = InsanityMixer(gameOfDice: LawfulGameOfDice())

        let actual = Array(subject.mix())

        for index in 0 ..< expectedCauseOfLawful.count {
            XCTAssertEqual(actual[index], expectedCauseOfLawful[index], "Unexpected value at index \(index)")
        }
        XCTAssertEqual(actual.count, expectedCauseOfLawful.count)
    }

    func testNext() {
        let subject = InsanityMixer(gameOfDice: LawfulGameOfDice())

        let actual = subject.next()

        var subjectRoll = subject.gameOfDice.roll()
        var actualRoll = actual.gameOfDice.roll()

        XCTAssertNotEqual(actualRoll.next(), subjectRoll.next())
    }
}
