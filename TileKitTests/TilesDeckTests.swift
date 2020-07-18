import TileKit
import XCTest

class TilesDeckTest: XCTestCase {
    func testMix() {
        let mixer = TestMixer(gameOfDice: LawfulGameOfDice())
        mixer.onMix = { [Tile(value: 1, score: 1)] }
        let (subject, _) = makeTestDeck(mixer: mixer)

        XCTAssertEqual(subject.tile, Tile(value: 1, score: 1))
        XCTAssertEqual(subject.mixer.mix(), [.empty])
    }

    func testMixNext() {
        let mixer = TestMixer(gameOfDice: LawfulGameOfDice())
        mixer.onMix = { [Tile(value: 2, score: 2), Tile(value: 1, score: 1)] }
        let (subject, _) = makeTestDeck(mixer: mixer)

        XCTAssertEqual(subject.tile, Tile(value: 1, score: 1))
        XCTAssertEqual(subject.mixer.mix(), [.empty])
    }

    func testDraw() {
        let mixer = TestMixer(gameOfDice: LawfulGameOfDice())
        let (subject, lottery) = makeTestDeck(mixer: mixer)
        lottery.onDraw = { _ in (.single(.empty), Tile(value: 3, score: 3)) }

        let actual = subject.next(maxValue: 0)

        XCTAssertEqual(actual.tile, Tile(value: 3, score: 3))
        XCTAssertNil(actual.lottery.draw(maxValue: 0))
    }

    func testDrawNext() {
        let mixer = TestMixer(gameOfDice: LawfulGameOfDice())
        let (subject, lottery) = makeTestDeck(mixer: mixer)
        lottery.onDraw = { _ in (.single(.empty), Tile(value: 3, score: 3)) }

        let actual = subject.next(maxValue: 0).next(maxValue: 0)

        XCTAssertEqual(actual.tile, .empty)
        XCTAssertNil(actual.lottery.draw(maxValue: 0))
    }
}
