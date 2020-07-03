public protocol GameOfDiceProtocol: Codable {
    associatedtype Generator: RandomNumberGenerator
    
    func roll() -> Generator
    func next() -> Self
}
