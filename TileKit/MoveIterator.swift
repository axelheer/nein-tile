public struct MoveIterator: IteratorProtocol {
    private var initial: Bool = true

    private var col: MoveData
    private var row: MoveData
    private var lay: MoveData

    public init(tiles: Tiles, direction: MoveDirection) {
        col = MoveData(dim: 0, dimCount: tiles.colCount, direction: direction)
        row = MoveData(dim: 1, dimCount: tiles.rowCount, direction: direction)
        lay = MoveData(dim: 2, dimCount: tiles.layCount, direction: direction)
    }

    private var current: Move {
        Move(
            source: TileIndex(col: col.source, row: row.source, lay: lay.source),
            target: TileIndex(col: col.target, row: row.target, lay: lay.target),
            marker: TileIndex(col: col.marker, row: row.marker, lay: lay.marker)
        )
    }

    public mutating func next() -> Move? {
        if col.blocked || row.blocked || lay.blocked {
            return nil
        }
        if initial {
            return start()
        }
        if col.next() {
            return current
        }
        col.reset()
        if row.next() {
            return current
        }
        row.reset()
        if lay.next() {
            return current
        }
        lay.reset()
        return nil
    }

    private mutating func start() -> Move? {
        initial = false
        col.reset()
        row.reset()
        lay.reset()
        return current
    }

    private struct MoveData {
        private let step: Int

        private let start: Int
        private let shift: Int
        private let count: Int

        public let blocked: Bool

        public init(dim: Int, dimCount: Int, direction: MoveDirection) {
            step = direction.rawValue % 2 == 1 ? 1 : -1

            let positive = dim + dim == direction.rawValue
            let negative = dim + dim + 1 == direction.rawValue

            start = negative ? 1 : 0
            shift = positive ? 1 : negative ? -1 : 0
            count = positive ? dimCount - 1 : dimCount

            blocked = start + shift == count + shift
        }

        private var index: Int = 0

        public var source: Int {
            index
        }

        public var target: Int {
            index + shift
        }

        public var marker: Int {
            shift == 0 ? index : step < 0 ? 0 : count - 1
        }

        public mutating func next() -> Bool {
            index += step
            return start <= index && index < count
        }

        public mutating func reset() {
            index = step > 0 ? start : count - 1
        }
    }
}
