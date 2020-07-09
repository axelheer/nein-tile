import TileKit
import XCTest

class DefaultDealerTests: XCTestCase {
    func testFirstDeal() {
        let tests = [
            (1, 1),
            (2, 1),
            (3, 1),
            (4, 2),
            (8, 4),
            (16, 8)
        ]

        let subject = DefaultDealer(gameOfDice: ChaoticGameOfDice())

        for (count, expected) in tests {
            let actual = subject.part(Array(repeating: TileIndex.empty, count: count))

            XCTAssertEqual(actual.count, expected, "Unexpected count at \(count)")
        }
    }

    func testFurtherDeals() {
        let tests = [
            (1, 1),
            (2, 1),
            (3, 1),
            (4, 1),
            (8, 2),
            (16, 4)
        ]

        let subject = DefaultDealer(gameOfDice: ChaoticGameOfDice()).next()

        for (count, expected) in tests {
            let actual = subject.part(Array(repeating: TileIndex.empty, count: count))

            XCTAssertEqual(actual.count, expected, "Unexpected count at \(count)")
        }
    }
}
