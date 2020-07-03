import TileKit
import XCTest

class AnyMergerTests: XCTestCase {
    func testSimple() throws {
        let expected = """
        {
          "mergerType" : "simple"
        }
        """
        
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        let decoder = JSONDecoder()
        
        let subject = AnyMerger(SimpleMerger())
        
        let encoded = try encoder.encode(subject)
        
        let actual = String(data: encoded, encoding: .utf8)!
        
        let decoded = try decoder.decode(AnyMerger.self, from: encoded)
        
        XCTAssertTrue(decoded.merger is SimpleMerger)
        XCTAssertEqual(actual, expected)
    }
    
    func testClassic() throws {
        let expected = """
        {
          "mergerType" : "classic"
        }
        """
        
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        let decoder = JSONDecoder()
        
        let subject = AnyMerger(ClassicMerger())
        
        let encoded = try encoder.encode(subject)
        
        let actual = String(data: encoded, encoding: .utf8)!
        
        let decoded = try decoder.decode(AnyMerger.self, from: encoded)
        
        XCTAssertTrue(decoded.merger is ClassicMerger)
        XCTAssertEqual(actual, expected)
    }
    
    func testDuality() throws {
        let expected = """
        {
          "mergerType" : "duality"
        }
        """
        
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        let decoder = JSONDecoder()
        
        let subject = AnyMerger(DualityMerger())
        
        let encoded = try encoder.encode(subject)
        
        let actual = String(data: encoded, encoding: .utf8)!
        
        let decoded = try decoder.decode(AnyMerger.self, from: encoded)
        
        XCTAssertTrue(decoded.merger is DualityMerger)
        XCTAssertEqual(actual, expected)
    }
    
    func testInsanity() throws {
        let expected = """
        {
          "mergerType" : "insanity"
        }
        """
        
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        let decoder = JSONDecoder()
        
        let subject = AnyMerger(InsanityMerger())
        
        let encoded = try encoder.encode(subject)
        
        let actual = String(data: encoded, encoding: .utf8)!
        
        let decoded = try decoder.decode(AnyMerger.self, from: encoded)
        
        XCTAssertTrue(decoded.merger is InsanityMerger)
        XCTAssertEqual(actual, expected)
    }
    
    func testFibonacci() throws {
        let expected = """
        {
          "mergerType" : "fibonacci"
        }
        """
        
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        let decoder = JSONDecoder()
        
        let subject = AnyMerger(FibonacciMerger())
        
        let encoded = try encoder.encode(subject)
        
        let actual = String(data: encoded, encoding: .utf8)!
        
        let decoded = try decoder.decode(AnyMerger.self, from: encoded)
        
        XCTAssertTrue(decoded.merger is FibonacciMerger)
        XCTAssertEqual(actual, expected)
    }
}
