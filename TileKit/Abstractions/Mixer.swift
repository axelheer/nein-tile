public protocol Mixer {
    func mix() -> [Tile]
    func next() -> Self
}
