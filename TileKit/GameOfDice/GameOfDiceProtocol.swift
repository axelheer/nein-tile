public protocol GameOfDiceProtocol {
    associatedtype Generator: RandomNumberGenerator
    
    func roll() -> Generator
    func next() -> Self
}
