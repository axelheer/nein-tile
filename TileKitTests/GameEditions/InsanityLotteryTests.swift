import TileKit
import XCTest

class InsanityLotteryTests: XCTestCase {
    let zero = Tile(value: 0, score: -1138)
    
    func testDraw() {
        let expectedCauseOfLawful: [Int: (TileHint, Tile)] = [
            6:  (.single(zero), zero)
        ]
        
        var subject = InsanityLottery(gameOfDice: LawfulGameOfDice())
        
        for iteration in 0 ..< 16 {
            let actual = subject.draw(maxValue: 1138)
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
        let subject = InsanityLottery(gameOfDice: LawfulGameOfDice())
        
        let actual = subject.next()
        
        var subjectRoll = subject.gameOfDice.roll()
        var actualRoll = actual.gameOfDice.roll()
        
        XCTAssertNotEqual(actualRoll.next(), subjectRoll.next())
    }
}
