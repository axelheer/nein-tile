import TileKit
import XCTest

class FibonacciMixerTests: XCTestCase {
    private let one   = Tile(value: 1, score: 0)
    private let two   = Tile(value: 2, score: 0)
    private let three = Tile(value: 3, score: 3)

    func testMix() {
        let expectedCauseOfLawful = [ one ]

        let subject = FibonacciMixer(gameOfDice: LawfulGameOfDice())

        let actual = Array(subject.mix())

        for index in 0 ..< expectedCauseOfLawful.count {
            XCTAssertEqual(actual[index], expectedCauseOfLawful[index], "Unexpected value at index \(index)")
        }
        XCTAssertEqual(actual.count, expectedCauseOfLawful.count)
    }

    func testNext() {
        let subject = FibonacciMixer(gameOfDice: LawfulGameOfDice())

        let actual = subject.next()

        var subjectRoll = subject.gameOfDice.roll()
        var actualRoll = actual.gameOfDice.roll()

        XCTAssertNotEqual(actualRoll.next(), subjectRoll.next())
    }
}
