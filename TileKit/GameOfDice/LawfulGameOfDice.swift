public struct LawfulGameOfDice: GameOfDiceProtocol {
    private let child: UInt64
    private let seed: UInt64
    
    public init() {
        self.init(parent: 1)
    }
    
    private init(parent: UInt64) {
        var random = PcgRandom(seed: parent)
        child = random.next()
        seed = random.next()
    }
    
    public func roll() -> some RandomNumberGenerator {
        return PcgRandom(seed: seed)
    }
    
    public func next() -> LawfulGameOfDice {
        return LawfulGameOfDice(parent: child)
    }
}
