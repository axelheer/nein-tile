public protocol Maker {
    mutating func makeDealer() -> Dealer
    mutating func makeLottery() -> Lottery
    mutating func makeMerger() -> Merger
    mutating func makeMixer() -> Mixer
}
