import Foundation
import TileKit

struct GameSamples {
    static let allSamples: [Game] = {
        return [simple, classic, duality, insanity, fibonacci].compactMap { $0 }
    }()

    static let simple = try? loadSample(name: "Simple")
    static let classic = try? loadSample(name: "Classic")
    static let duality = try? loadSample(name: "Duality")
    static let insanity = try? loadSample(name: "Insanity")
    static let fibonacci = try? loadSample(name: "Fibonacci")

    static func loadSample(name: String) throws -> Game {
        let url = Bundle.main.url(forResource: name + "Sample", withExtension: "json")!
        let raw = try Data(contentsOf: url)
        let game = try JSONDecoder().decode(Game.self, from: raw)
        return game
    }
}
