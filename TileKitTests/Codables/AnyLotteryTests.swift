import TileKit
import XCTest

class AnyLotteryTests: XCTestCase {
    func testDeterministicSimple() throws {
        let expected = """
        {
          "deterministic" : true,
          "lottery" : {
            "gameOfDice" : {
              "child" : 15470614175582615882,
              "seed" : 9359877311749135890
            }
          },
          "lotteryType" : "simple"
        }
        """
        
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        let decoder = JSONDecoder()
        
        let subject = AnyLottery(SimpleLottery(gameOfDice: NeutralGameOfDice()))
        
        let encoded = try encoder.encode(subject)
        
        let actual = String(data: encoded, encoding: .utf8)!
        
        let decoded = try decoder.decode(AnyLottery.self, from: encoded)
        
        XCTAssertTrue(decoded.lottery is SimpleLottery<NeutralGameOfDice>)
        XCTAssertEqual(trimGameOfDice(actual), trimGameOfDice(expected))
    }
    
    func testDeterministicClassic() throws {
        let expected = """
        {
          "deterministic" : true,
          "lottery" : {
            "gameOfDice" : {
              "child" : 15470614175582615882,
              "seed" : 9359877311749135890
            }
          },
          "lotteryType" : "classic"
        }
        """
        
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        let decoder = JSONDecoder()
        
        let subject = AnyLottery(ClassicLottery(gameOfDice: NeutralGameOfDice()))
        
        let encoded = try encoder.encode(subject)
        
        let actual = String(data: encoded, encoding: .utf8)!
        
        let decoded = try decoder.decode(AnyLottery.self, from: encoded)
        
        XCTAssertTrue(decoded.lottery is ClassicLottery<NeutralGameOfDice>)
        XCTAssertEqual(trimGameOfDice(actual), trimGameOfDice(expected))
    }
    
    func testDeterministicDuality() throws {
        let expected = """
        {
          "deterministic" : true,
          "lottery" : {
            "gameOfDice" : {
              "child" : 15470614175582615882,
              "seed" : 9359877311749135890
            }
          },
          "lotteryType" : "duality"
        }
        """
        
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        let decoder = JSONDecoder()
        
        let subject = AnyLottery(DualityLottery(gameOfDice: NeutralGameOfDice()))
        
        let encoded = try encoder.encode(subject)
        
        let actual = String(data: encoded, encoding: .utf8)!
        
        let decoded = try decoder.decode(AnyLottery.self, from: encoded)
        
        XCTAssertTrue(decoded.lottery is DualityLottery<NeutralGameOfDice>)
        XCTAssertEqual(trimGameOfDice(actual), trimGameOfDice(expected))
    }
    
    func testDeterministicInsanity() throws {
        let expected = """
        {
          "deterministic" : true,
          "lottery" : {
            "gameOfDice" : {
              "child" : 15470614175582615882,
              "seed" : 9359877311749135890
            }
          },
          "lotteryType" : "insanity"
        }
        """
        
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        let decoder = JSONDecoder()
        
        let subject = AnyLottery(InsanityLottery(gameOfDice: NeutralGameOfDice()))
        
        let encoded = try encoder.encode(subject)
        
        let actual = String(data: encoded, encoding: .utf8)!
        
        let decoded = try decoder.decode(AnyLottery.self, from: encoded)
        
        XCTAssertTrue(decoded.lottery is InsanityLottery<NeutralGameOfDice>)
        XCTAssertEqual(trimGameOfDice(actual), trimGameOfDice(expected))
    }
    
    func testDeterministicFibonacci() throws {
        let expected = """
        {
          "deterministic" : true,
          "lottery" : {
            "gameOfDice" : {
              "child" : 15470614175582615882,
              "seed" : 9359877311749135890
            }
          },
          "lotteryType" : "fibonacci"
        }
        """
        
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        let decoder = JSONDecoder()
        
        let subject = AnyLottery(FibonacciLottery(gameOfDice: NeutralGameOfDice()))
        
        let encoded = try encoder.encode(subject)
        
        let actual = String(data: encoded, encoding: .utf8)!
        
        let decoded = try decoder.decode(AnyLottery.self, from: encoded)
        
        XCTAssertTrue(decoded.lottery is FibonacciLottery<NeutralGameOfDice>)
        XCTAssertEqual(trimGameOfDice(actual), trimGameOfDice(expected))
    }
    
    func testNonDeterministicSimple() throws {
        let expected = """
        {
          "deterministic" : false,
          "lottery" : {
            "gameOfDice" : {
                "seed" : 9359877311749135890
            }
          },
          "lotteryType" : "simple"
        }
        """
        
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        let decoder = JSONDecoder()
        
        let subject = AnyLottery(SimpleLottery(gameOfDice: ChaoticGameOfDice()))
        
        let encoded = try encoder.encode(subject)
        
        let actual = String(data: encoded, encoding: .utf8)!
        
        let decoded = try decoder.decode(AnyLottery.self, from: encoded)
        
        XCTAssertTrue(decoded.lottery is SimpleLottery<ChaoticGameOfDice>)
        XCTAssertEqual(trimGameOfDice(actual), trimGameOfDice(expected))
    }
    
    func testNonDeterministicClassic() throws {
        let expected = """
        {
          "deterministic" : false,
          "lottery" : {
            "gameOfDice" : {
                "seed" : 9359877311749135890
            }
          },
          "lotteryType" : "classic"
        }
        """
        
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        let decoder = JSONDecoder()
        
        let subject = AnyLottery(ClassicLottery(gameOfDice: ChaoticGameOfDice()))
        
        let encoded = try encoder.encode(subject)
        
        let actual = String(data: encoded, encoding: .utf8)!
        
        let decoded = try decoder.decode(AnyLottery.self, from: encoded)
        
        XCTAssertTrue(decoded.lottery is ClassicLottery<ChaoticGameOfDice>)
        XCTAssertEqual(trimGameOfDice(actual), trimGameOfDice(expected))
    }
    
    func testNonDeterministicDuality() throws {
        let expected = """
        {
          "deterministic" : false,
          "lottery" : {
            "gameOfDice" : {
                "seed" : 9359877311749135890
            }
          },
          "lotteryType" : "duality"
        }
        """
        
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        let decoder = JSONDecoder()
        
        let subject = AnyLottery(DualityLottery(gameOfDice: ChaoticGameOfDice()))
        
        let encoded = try encoder.encode(subject)
        
        let actual = String(data: encoded, encoding: .utf8)!
        
        let decoded = try decoder.decode(AnyLottery.self, from: encoded)
        
        XCTAssertTrue(decoded.lottery is DualityLottery<ChaoticGameOfDice>)
        XCTAssertEqual(trimGameOfDice(actual), trimGameOfDice(expected))
    }
    
    func testNonDeterministicInsanity() throws {
        let expected = """
        {
          "deterministic" : false,
          "lottery" : {
            "gameOfDice" : {
                "seed" : 9359877311749135890
            }
          },
          "lotteryType" : "insanity"
        }
        """
        
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        let decoder = JSONDecoder()
        
        let subject = AnyLottery(InsanityLottery(gameOfDice: ChaoticGameOfDice()))
        
        let encoded = try encoder.encode(subject)
        
        let actual = String(data: encoded, encoding: .utf8)!
        
        let decoded = try decoder.decode(AnyLottery.self, from: encoded)
        
        XCTAssertTrue(decoded.lottery is InsanityLottery<ChaoticGameOfDice>)
        XCTAssertEqual(trimGameOfDice(actual), trimGameOfDice(expected))
    }
    
    func testNonDeterministicFibonacci() throws {
        let expected = """
        {
          "deterministic" : false,
          "lottery" : {
            "gameOfDice" : {
                "seed" : 9359877311749135890
            }
          },
          "lotteryType" : "fibonacci"
        }
        """
        
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        let decoder = JSONDecoder()
        
        let subject = AnyLottery(FibonacciLottery(gameOfDice: ChaoticGameOfDice()))
        
        let encoded = try encoder.encode(subject)
        
        let actual = String(data: encoded, encoding: .utf8)!
        
        let decoded = try decoder.decode(AnyLottery.self, from: encoded)
        
        XCTAssertTrue(decoded.lottery is FibonacciLottery<ChaoticGameOfDice>)
        XCTAssertEqual(trimGameOfDice(actual), trimGameOfDice(expected))
    }
}
