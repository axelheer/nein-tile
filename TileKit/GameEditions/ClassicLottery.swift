public struct ClassicLottery<GameOfDice: GameOfDiceProtocol>: Lottery {
    public let gameOfDice: GameOfDice

    public init(gameOfDice: GameOfDice) {
        self.gameOfDice = gameOfDice
    }
    
    private let six = Tile(value: 6, score: 9)

    public func draw(maxValue: Int) -> (TileHint, Tile)? {
        let maxValue = maxValue / 8
        guard six.value <= maxValue else {
            return nil
        }
        var random = gameOfDice.roll()
        guard random.next(upperBound: UInt(21)) == 0 else {
            return nil
        }
        let pool = makePool(maxValue: maxValue)
        if pool.count == 1 {
            return (.single(pool[0]), pool[0])
        }
        let index = Int.random(in: 0 ..< pool.count, using: &random)
        if pool.count == 2 {
            return (.either(pool[0], pool[1]), pool[index])
        }
        let position = Int.random(
            in: max(1, index - pool.count + 4) ... min(3, index + 1),
            using: &random)
        return (
            .threes(pool[index - position + 1],
                    pool[index - position + 2],
                    pool[index - position + 3]),
            pool[index]
        )
    }
    
    private func makePool(maxValue: Int) -> [Tile] {
        let count = (maxValue / six.value).trailingZeroBitCount + 1
        var pool = Array(repeating: six, count: count)
        for index in 1 ..< pool.count {
            let last = pool[index - 1]
            pool[index] = Tile(
                value: last.value |+ last.value,
                score: last.score |+ last.score |+ last.score
            )
        }
        return pool
    }

    public func next() -> ClassicLottery<GameOfDice> {
        return ClassicLottery(gameOfDice: gameOfDice.next())
    }
}
