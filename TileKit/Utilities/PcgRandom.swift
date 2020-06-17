// Based on: https://github.com/paiv/swift-pcg-random
// ... but without __uint128_t requirement ...

internal struct PcgRandom: RandomNumberGenerator {
    private static let increment: UInt128 = UInt128(high: 6364136223846793005, low: 1442695040888963407)
    private static let multiplier: UInt128 = UInt128(high: 2549297995355413924, low: 4865540595714422341)
    
    private var state: UInt128
    
    public init(seed: UInt64) {
        state = Self.advance(state: Self.increment &+ seed)
    }
    
    public mutating func next() -> UInt64 {
        let next = Self.advance(state: state)
        
        let rot = Int32(truncatingIfNeeded: next.high >> 58)
        let xor = next.high ^ next.low
        let res = (xor >> rot) | (xor << ((-rot) & 63))
        
        state = next
        
        return res
    }
    
    private static func advance(state: UInt128) -> UInt128 {
        return state &* Self.multiplier &+ Self.increment
    }
}

fileprivate struct UInt128 {
    public let high: UInt64
    public let low: UInt64
    
    public static func &+(left: UInt128, right: UInt64) -> UInt128 {
        let (l, o) = left.low.addingReportingOverflow(right)
        let h = left.high &+ (o ? 1 : 0)
        return UInt128(high: h, low: l)
    }
    
    public static func &+(left: UInt128, right: UInt128) -> UInt128 {
        let (l, o) = left.low.addingReportingOverflow(right.low)
        let h = left.high &+ right.high &+ (o ? 1 : 0)
        return UInt128(high: h, low: l)
    }
    
    public static func &*(left: UInt128, right: UInt128) -> UInt128 {
        let l = left.low.multipliedFullWidth(by: right.low)
        let h = (left.low &* right.high) &+ (left.high &* right.low)
        return UInt128(high: h &+ l.high, low: l.low)
    }
}
