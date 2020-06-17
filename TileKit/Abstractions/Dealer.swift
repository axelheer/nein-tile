public protocol Dealer {
    func part(_ indices: [TileIndex]) -> [TileIndex]
    func next() -> Self
}
