import TileKit
import XCTest

class AnyDealerTests: XCTestCase {
    func testDeterministicDefault() throws {
        let expected = """
        {
          "dealer" : {
            "gameOfDice" : {
              "child" : 15470614175582615882,
              "seed" : 9359877311749135890
            },
            "ratio" : 2
          },
          "dealerType" : "default",
          "deterministic" : true
        }
        """
        
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        let decoder = JSONDecoder()
        
        let subject = AnyDealer(DefaultDealer(gameOfDice: NeutralGameOfDice()))
        
        let encoded = try encoder.encode(subject)
        
        let actual = String(data: encoded, encoding: .utf8)!
        
        let decoded = try decoder.decode(AnyDealer.self, from: encoded)
        
        XCTAssertTrue(decoded.dealer is DefaultDealer<NeutralGameOfDice>)
        XCTAssertEqual(trimGameOfDice(actual), trimGameOfDice(expected))
    }
    
    func testNonDeterministicDefault() throws {
        let expected = """
        {
          "dealer" : {
            "gameOfDice" : {
                "seed" : 9359877311749135890
            },
            "ratio" : 2
          },
          "dealerType" : "default",
          "deterministic" : false
        }
        """
        
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        let decoder = JSONDecoder()
        
        let subject = AnyDealer(DefaultDealer(gameOfDice: ChaoticGameOfDice()))
        
        let encoded = try encoder.encode(subject)
        
        let actual = String(data: encoded, encoding: .utf8)!
        
        let decoded = try decoder.decode(AnyDealer.self, from: encoded)
        
        XCTAssertTrue(decoded.dealer is DefaultDealer<ChaoticGameOfDice>)
        XCTAssertEqual(trimGameOfDice(actual), trimGameOfDice(expected))
    }
}
