import TileKit
import XCTest

// swiftlint:disable type_body_length

class AnyMixerTests: XCTestCase {
    func testDeterministicSimple() throws {
        let expected = """
        {
          "deterministic" : true,
          "mixer" : {
            "gameOfDice" : {
              "child" : 15470614175582615882,
              "seed" : 9359877311749135890
            }
          },
          "mixerType" : "simple"
        }
        """

        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        let decoder = JSONDecoder()

        let subject = AnyMixer(SimpleMixer(gameOfDice: NeutralGameOfDice()))

        let encoded = try encoder.encode(subject)

        let actual = String(data: encoded, encoding: .utf8)!

        let decoded = try decoder.decode(AnyMixer.self, from: encoded)

        XCTAssertTrue(decoded.mixer is SimpleMixer<NeutralGameOfDice>)
        XCTAssertEqual(trimGameOfDice(actual), trimGameOfDice(expected))
    }

    func testDeterministicClassic() throws {
        let expected = """
        {
          "deterministic" : true,
          "mixer" : {
            "gameOfDice" : {
              "child" : 15470614175582615882,
              "seed" : 9359877311749135890
            }
          },
          "mixerType" : "classic"
        }
        """

        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        let decoder = JSONDecoder()

        let subject = AnyMixer(ClassicMixer(gameOfDice: NeutralGameOfDice()))

        let encoded = try encoder.encode(subject)

        let actual = String(data: encoded, encoding: .utf8)!

        let decoded = try decoder.decode(AnyMixer.self, from: encoded)

        XCTAssertTrue(decoded.mixer is ClassicMixer<NeutralGameOfDice>)
        XCTAssertEqual(trimGameOfDice(actual), trimGameOfDice(expected))
    }

    func testDeterministicDuality() throws {
        let expected = """
        {
          "deterministic" : true,
          "mixer" : {
            "gameOfDice" : {
              "child" : 15470614175582615882,
              "seed" : 9359877311749135890
            }
          },
          "mixerType" : "duality"
        }
        """

        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        let decoder = JSONDecoder()

        let subject = AnyMixer(DualityMixer(gameOfDice: NeutralGameOfDice()))

        let encoded = try encoder.encode(subject)

        let actual = String(data: encoded, encoding: .utf8)!

        let decoded = try decoder.decode(AnyMixer.self, from: encoded)

        XCTAssertTrue(decoded.mixer is DualityMixer<NeutralGameOfDice>)
        XCTAssertEqual(trimGameOfDice(actual), trimGameOfDice(expected))
    }

    func testDeterministicInsanity() throws {
        let expected = """
        {
          "deterministic" : true,
          "mixer" : {
            "gameOfDice" : {
              "child" : 15470614175582615882,
              "seed" : 9359877311749135890
            }
          },
          "mixerType" : "insanity"
        }
        """

        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        let decoder = JSONDecoder()

        let subject = AnyMixer(InsanityMixer(gameOfDice: NeutralGameOfDice()))

        let encoded = try encoder.encode(subject)

        let actual = String(data: encoded, encoding: .utf8)!

        let decoded = try decoder.decode(AnyMixer.self, from: encoded)

        XCTAssertTrue(decoded.mixer is InsanityMixer<NeutralGameOfDice>)
        XCTAssertEqual(trimGameOfDice(actual), trimGameOfDice(expected))
    }

    func testDeterministicFibonacci() throws {
        let expected = """
        {
          "deterministic" : true,
          "mixer" : {
            "gameOfDice" : {
              "child" : 15470614175582615882,
              "seed" : 9359877311749135890
            }
          },
          "mixerType" : "fibonacci"
        }
        """

        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        let decoder = JSONDecoder()

        let subject = AnyMixer(FibonacciMixer(gameOfDice: NeutralGameOfDice()))

        let encoded = try encoder.encode(subject)

        let actual = String(data: encoded, encoding: .utf8)!

        let decoded = try decoder.decode(AnyMixer.self, from: encoded)

        XCTAssertTrue(decoded.mixer is FibonacciMixer<NeutralGameOfDice>)
        XCTAssertEqual(trimGameOfDice(actual), trimGameOfDice(expected))
    }

    func testNonDeterministicSimple() throws {
        let expected = """
        {
          "deterministic" : false,
          "mixer" : {
            "gameOfDice" : {
                "seed" : 9359877311749135890
            }
          },
          "mixerType" : "simple"
        }
        """

        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        let decoder = JSONDecoder()

        let subject = AnyMixer(SimpleMixer(gameOfDice: ChaoticGameOfDice()))

        let encoded = try encoder.encode(subject)

        let actual = String(data: encoded, encoding: .utf8)!

        let decoded = try decoder.decode(AnyMixer.self, from: encoded)

        XCTAssertTrue(decoded.mixer is SimpleMixer<ChaoticGameOfDice>)
        XCTAssertEqual(trimGameOfDice(actual), trimGameOfDice(expected))
    }

    func testNonDeterministicClassic() throws {
        let expected = """
        {
          "deterministic" : false,
          "mixer" : {
            "gameOfDice" : {
                "seed" : 9359877311749135890
            }
          },
          "mixerType" : "classic"
        }
        """

        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        let decoder = JSONDecoder()

        let subject = AnyMixer(ClassicMixer(gameOfDice: ChaoticGameOfDice()))

        let encoded = try encoder.encode(subject)

        let actual = String(data: encoded, encoding: .utf8)!

        let decoded = try decoder.decode(AnyMixer.self, from: encoded)

        XCTAssertTrue(decoded.mixer is ClassicMixer<ChaoticGameOfDice>)
        XCTAssertEqual(trimGameOfDice(actual), trimGameOfDice(expected))
    }

    func testNonDeterministicDuality() throws {
        let expected = """
        {
          "deterministic" : false,
          "mixer" : {
            "gameOfDice" : {
                "seed" : 9359877311749135890
            }
          },
          "mixerType" : "duality"
        }
        """

        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        let decoder = JSONDecoder()

        let subject = AnyMixer(DualityMixer(gameOfDice: ChaoticGameOfDice()))

        let encoded = try encoder.encode(subject)

        let actual = String(data: encoded, encoding: .utf8)!

        let decoded = try decoder.decode(AnyMixer.self, from: encoded)

        XCTAssertTrue(decoded.mixer is DualityMixer<ChaoticGameOfDice>)
        XCTAssertEqual(trimGameOfDice(actual), trimGameOfDice(expected))
    }

    func testNonDeterministicInsanity() throws {
        let expected = """
        {
          "deterministic" : false,
          "mixer" : {
            "gameOfDice" : {
                "seed" : 9359877311749135890
            }
          },
          "mixerType" : "insanity"
        }
        """

        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        let decoder = JSONDecoder()

        let subject = AnyMixer(InsanityMixer(gameOfDice: ChaoticGameOfDice()))

        let encoded = try encoder.encode(subject)

        let actual = String(data: encoded, encoding: .utf8)!

        let decoded = try decoder.decode(AnyMixer.self, from: encoded)

        XCTAssertTrue(decoded.mixer is InsanityMixer<ChaoticGameOfDice>)
        XCTAssertEqual(trimGameOfDice(actual), trimGameOfDice(expected))
    }

    func testNonDeterministicFibonacci() throws {
        let expected = """
        {
          "deterministic" : false,
          "mixer" : {
            "gameOfDice" : {
                "seed" : 9359877311749135890
            }
          },
          "mixerType" : "fibonacci"
        }
        """

        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        let decoder = JSONDecoder()

        let subject = AnyMixer(FibonacciMixer(gameOfDice: ChaoticGameOfDice()))

        let encoded = try encoder.encode(subject)

        let actual = String(data: encoded, encoding: .utf8)!

        let decoded = try decoder.decode(AnyMixer.self, from: encoded)

        XCTAssertTrue(decoded.mixer is FibonacciMixer<ChaoticGameOfDice>)
        XCTAssertEqual(trimGameOfDice(actual), trimGameOfDice(expected))
    }
}
