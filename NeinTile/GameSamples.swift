import Foundation
import TileKit

struct GameSamples {
    static let allSamples: [Game] = {
       return [simple, classic, duality, insanity, fibonacci]
    }()
    
    static let simple: Game = loadSample(name: "Simple")
    static let classic: Game = loadSample(name: "Classic")
    static let duality: Game = loadSample(name: "Duality")
    static let insanity: Game = loadSample(name: "Insanity")
    static let fibonacci: Game = loadSample(name: "Fibonacci")
    
    static func loadSample(name: String) -> Game {
        let url = Bundle.main.url(forResource: name + "Sample", withExtension: "json")!
        let raw = try! Data(contentsOf: url)
        let game = try! JSONDecoder().decode(Game.self, from: raw)
        return game
    }
}
