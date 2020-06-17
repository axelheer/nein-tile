import TileKit
import XCTest

class FibonacciLotteryTests: XCTestCase {
    let two   = Tile(value: 2, score: 0)
    let three = Tile(value: 3, score: 3)
    
    func testDraw() {
        let expectedCauseOfLawful: [Int: (TileHint, Tile)] = [
            0:  (.either(two, three), three),
            2:  (.either(two, three), three),
            4:  (.either(two, three), two),
            5:  (.either(two, three), two),
            6:  (.either(two, three), two),
            8:  (.either(two, three), three),
            11:  (.either(two, three), two),
            12:  (.either(two, three), three),
            15:  (.either(two, three), two),
            17:  (.either(two, three), two),
            20:  (.either(two, three), three),
            22:  (.either(two, three), two),
        ]
        
        var subject = FibonacciLottery(gameOfDice: LawfulGameOfDice())
        
        for iteration in 0 ..< 27 {
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
        let subject = FibonacciLottery(gameOfDice: LawfulGameOfDice())
        
        let actual = subject.next()
        
        var subjectRoll = subject.gameOfDice.roll()
        var actualRoll = actual.gameOfDice.roll()
        
        XCTAssertNotEqual(actualRoll.next(), subjectRoll.next())
    }
}
