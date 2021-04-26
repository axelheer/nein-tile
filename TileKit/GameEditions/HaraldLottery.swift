public struct HaraldLottery<GameOfDice: GameOfDiceProtocol>: Lottery, Codable {
    public let gameOfDice: GameOfDice

    public init(gameOfDice: GameOfDice) {
        self.gameOfDice = gameOfDice
    }

    public func draw(maxValue: Int) -> (TileHint, Tile)? {
        return nil
    }

    public func next() -> HaraldLottery<GameOfDice> {
        return HaraldLottery(gameOfDice: gameOfDice.next())
    }

    private enum CodingKeys: String, CodingKey {
        case gameOfDice
    }
}
