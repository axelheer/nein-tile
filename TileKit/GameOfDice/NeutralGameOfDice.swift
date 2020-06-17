public struct NeutralGameOfDice: GameOfDiceProtocol {
    private static var random = SystemRandomNumberGenerator()
    
    private let child: UInt64
    private let seed: UInt64
    
    public init() {
        self.init(parent: Self.random.next())
    }
    
    private init(parent: UInt64) {
        var random = PcgRandom(seed: parent)
        child = random.next()
        seed = random.next()
    }
    
    public func roll() -> some RandomNumberGenerator {
        return PcgRandom(seed: seed)
    }
    
    public func next() -> NeutralGameOfDice {
        return NeutralGameOfDice(parent: child)
    }
}
