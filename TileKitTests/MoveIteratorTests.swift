import TileKit
import XCTest

class MoveIteratorTests: XCTestCase {
    func testBlockedRight() {
        let tightTiles = makeTestTiles(colCount: 1)

        var subject = MoveIterator(tiles: tightTiles, direction: .right)

        XCTAssertNil(subject.next())
    }

    func testBlockedLeft() {
        let tightTiles = makeTestTiles(colCount: 1)

        var subject = MoveIterator(tiles: tightTiles, direction: .left)

        XCTAssertNil(subject.next())
    }

    func testBlockedUp() {
        let tightTiles = makeTestTiles(rowCount: 1)

        var subject = MoveIterator(tiles: tightTiles, direction: .top)

        XCTAssertNil(subject.next())
    }

    func testBlockedDown() {
        let tightTiles = makeTestTiles(rowCount: 1)

        var subject = MoveIterator(tiles: tightTiles, direction: .bottom)

        XCTAssertNil(subject.next())
    }

    func testBlockedForward() {
        let tightTiles = makeTestTiles(layCount: 1)

        var subject = MoveIterator(tiles: tightTiles, direction: .front)

        XCTAssertNil(subject.next())
    }

    func testBlockedBackward() {
        let tightTiles = makeTestTiles(layCount: 1)

        var subject = MoveIterator(tiles: tightTiles, direction: .back)

        XCTAssertNil(subject.next())
    }

    // MARK: Test Move

    func testMoveRight() {
        let tiles = makeTestTiles()

        let subject = MoveIterator(tiles: tiles, direction: .right)

        assertMoves(tiles, subject, source: { 63 - $0 - $0 / 3 }, target: { $0 + 1 })
    }

    func testMoveLeft() {
        let tiles = makeTestTiles()

        let subject = MoveIterator(tiles: tiles, direction: .left)

        assertMoves(tiles, subject, source: { 2 + $0 + $0 / 3 }, target: { $0 - 1 })
    }

    func testMoveUp() {
        let tiles = makeTestTiles()

        let subject = MoveIterator(tiles: tiles, direction: .top)

        assertMoves(tiles, subject, source: { 60 - $0 - 4 * ($0 / 12) }, target: { $0 + 4 })
    }

    func testMoveDown() {
        let tiles = makeTestTiles()

        let subject = MoveIterator(tiles: tiles, direction: .bottom)

        assertMoves(tiles, subject, source: { 5 + $0 + 4 * ($0 / 12) }, target: { $0 - 4 })
    }

    func testMoveForward() {
        let tiles = makeTestTiles()

        let subject = MoveIterator(tiles: tiles, direction: .front)

        assertMoves(tiles, subject, source: { 48 - $0 }, target: { $0 + 16 })
    }

    func testMoveBackward() {
        let tiles = makeTestTiles()

        let subject = MoveIterator(tiles: tiles, direction: .back)

        assertMoves(tiles, subject, source: { 17 + $0 }, target: { $0 - 16 })
    }

    func assertMoves(_ tiles: Tiles, _ subject: MoveIterator, source: (Int) -> Int, target: (Int) -> Int) {
        var iteration = 0
        var iterator = subject

        while let actual = iterator.next() {
            let expectedSource = source(iteration)
            let expectedTarget = target(expectedSource)

            let actualSource = tiles[actual.source].value
            let actualTarget = tiles[actual.target].value

            XCTAssertEqual(actualSource, expectedSource, "Unexpected source at iteration \(iteration)")
            XCTAssertEqual(actualTarget, expectedTarget, "Unexpected target at iteration \(iteration)")

            iteration += 1
        }

        XCTAssertEqual(iteration, 48)
    }

    // MARK: Test Mark

    func testMarkRight() {
        let tiles = makeTestTiles()

        let subject = MoveIterator(tiles: tiles, direction: .right)

        assertMarks(subject, mark: { TileIndex(col: 0, row: 3 - $0 / 3 % 4, lay: 3 - $0 / 12) })
    }

    func testMarkLeft() {
        let tiles = makeTestTiles()

        let subject = MoveIterator(tiles: tiles, direction: .left)

        assertMarks(subject, mark: { TileIndex(col: 3, row: $0 / 3 % 4, lay: $0 / 12) })
    }

    func testMarkUp() {
        let tiles = makeTestTiles()

        let subject = MoveIterator(tiles: tiles, direction: .top)

        assertMarks(subject, mark: { TileIndex(col: 3 - $0 % 4, row: 0, lay: 3 - $0 / 12) })
    }

    func testMarkDown() {
        let tiles = makeTestTiles()

        let subject = MoveIterator(tiles: tiles, direction: .bottom)

        assertMarks(subject, mark: { TileIndex(col: $0 % 4, row: 3, lay: $0 / 12) })
    }

    func testMarkForward() {
        let tiles = makeTestTiles()

        let subject = MoveIterator(tiles: tiles, direction: .front)

        assertMarks(subject, mark: { TileIndex(col: 3 - $0 % 4, row: 3 - $0 / 4 % 4, lay: 0) })
    }

    func testMarkBackward() {
        let tiles = makeTestTiles()

        let subject = MoveIterator(tiles: tiles, direction: .back)

        assertMarks(subject, mark: { TileIndex(col: $0 % 4, row: $0 / 4 % 4, lay: 3) })
    }

    func assertMarks(_ subject: MoveIterator, mark: (Int) -> TileIndex) {
        var iterator = subject
        var iteration = 0

        while let move = iterator.next() {
            let expected = mark(iteration)
            let actual = move.marker

            XCTAssertEqual(actual, expected, "Unexpected marker at iteration \(iteration)")

            iteration += 1
        }

        XCTAssertEqual(iteration, 48)
    }
}
