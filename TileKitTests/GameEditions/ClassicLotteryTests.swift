import TileKit
import XCTest

class ClassicLotteryTests: XCTestCase {
    func testDrawEmpty() {
        var subject = ClassicLottery(gameOfDice: LawfulGameOfDice())

        for iteration in 0 ..< 84 {
            XCTAssertNil(subject.draw(maxValue: 24), "Unexpected value at iteration \(iteration)")
            subject = subject.next()
        }
    }

    let six = Tile(value: 6, score: 9)

    func testDrawSingle() {
        let expectedCauseOfLawful: [Int: (TileHint, Tile)] = [
            6: (.single(six), six),
            22: (.single(six), six)
        ]

        var subject = ClassicLottery(gameOfDice: LawfulGameOfDice())

        for iteration in 0 ..< 84 {
            let actual = subject.draw(maxValue: 48)
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

    let twelve = Tile(value: 12, score: 27)

    func testDrawEither() {
        let expectedCauseOfLawful: [Int: (TileHint, Tile)] = [
            6: (.either(six, twelve), twelve),
            22: (.either(six, twelve), six)
        ]

        var subject = ClassicLottery(gameOfDice: LawfulGameOfDice())

        for iteration in 0 ..< 84 {
            let actual = subject.draw(maxValue: 96)
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

    let twentyfour  = Tile(value: 24, score: 81)
    let fourtyeight = Tile(value: 48, score: 243)
    let ninetysix   = Tile(value: 96, score: 729)

    func testDrawThrees() {
        let expectedCauseOfLawful: [Int: (TileHint, Tile)] = [
            6: (.threes(twentyfour, fourtyeight, ninetysix), fourtyeight),
            22: (.threes(six, twelve, twentyfour), six)
        ]

        var subject = ClassicLottery(gameOfDice: LawfulGameOfDice())

        for iteration in 0 ..< 84 {
            let actual = subject.draw(maxValue: 768)
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
        let subject = ClassicLottery(gameOfDice: LawfulGameOfDice())

        let actual = subject.next()

        var subjectRoll = subject.gameOfDice.roll()
        var actualRoll = actual.gameOfDice.roll()

        XCTAssertNotEqual(actualRoll.next(), subjectRoll.next())
    }

    func testOverflow() {
        var subject = ClassicLottery(gameOfDice: LawfulGameOfDice())

        for _ in 0 ..< 6 {
            subject = subject.next()
        }

        let actual = subject.draw(maxValue: (1 << (.bitWidth - 3)) * 3)

        XCTAssertNotNil(actual)
    }
}
