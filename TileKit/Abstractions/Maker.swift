public protocol Maker {
    func makeDealer() -> Dealer
    func makeLottery() -> Lottery
    func makeMerger() -> Merger
    func makeMixer() -> Mixer
}
