public protocol Lottery {
    func draw(maxValue: Int) -> (TileHint, Tile)?
    func next() -> Self
}
