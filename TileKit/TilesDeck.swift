public struct TilesDeck: Codable {
    public let lottery: AnyLottery
    public let mixer: AnyMixer

    public let tile: Tile
    public let hint: TileHint

    private let stack: [Tile]

    public init(mixer: AnyMixer, lottery: AnyLottery) {
        let stack = mixer.mix()
        guard let tile = stack.last else {
            fatalError("Out of tiles")
        }
        self.init(
            stack: stack.dropLast(),
            tile: tile,
            hint: .single(tile),
            mixer: mixer.next(),
            lottery: lottery
        )
    }

    private init(stack: [Tile], tile: Tile, hint: TileHint, mixer: AnyMixer, lottery: AnyLottery) {
        self.stack = stack
        self.tile = tile
        self.hint = hint
        self.mixer = mixer
        self.lottery = lottery
    }

    public func next(maxValue: Int) -> TilesDeck {
        if let (hint, tile) = lottery.draw(maxValue: maxValue) {
            return TilesDeck(
                stack: stack,
                tile: tile,
                hint: hint,
                mixer: mixer,
                lottery: lottery.next()
            )
        }
        if let tile = stack.last {
            return TilesDeck(
                stack: stack.dropLast(),
                tile: tile,
                hint: .single(tile),
                mixer: mixer,
                lottery: lottery.next()
            )
        }
        return TilesDeck(
            mixer: mixer,
            lottery: lottery.next()
        )
    }
}
