public struct GameMaker: Codable {
    public let colCount: Int
    public let rowCount: Int
    public let layCount: Int
    
    public let edition: GameEdition
    
    public let deterministic: Bool
    public let apprentice: Bool
    public let slippery: Bool
    
    public init() {
        self.init(
            colCount: 4,
            rowCount: 4,
            layCount: 1,
            edition: .simple,
            deterministic: true,
            apprentice: true,
            slippery: true
        )
    }
    
    private init(colCount: Int, rowCount: Int, layCount: Int, edition: GameEdition, deterministic: Bool, apprentice: Bool, slippery: Bool) {
        self.colCount = colCount
        self.rowCount = rowCount
        self.layCount = layCount
        
        self.edition = edition
        
        self.deterministic = deterministic
        self.apprentice = apprentice
        self.slippery = slippery
    }
    
    public func use(colCount: Int, rowCount: Int, layCount: Int = 1) -> GameMaker {
        precondition(colCount > 0, "Count out of range")
        precondition(rowCount > 0, "Count out of range")
        precondition(layCount > 0, "Count out of range")
        
        return GameMaker(
            colCount: colCount,
            rowCount: rowCount,
            layCount: layCount,
            edition: edition,
            deterministic: deterministic,
            apprentice: apprentice,
            slippery: slippery
        )
    }
    
    public func use(edition: GameEdition) -> GameMaker {
       return GameMaker(
            colCount: colCount,
            rowCount: rowCount,
            layCount: layCount,
            edition: edition,
            deterministic: deterministic,
            apprentice: apprentice,
            slippery: slippery
        )
    }
    
    public func be(deterministic: Bool) -> GameMaker {
        return GameMaker(
            colCount: colCount,
            rowCount: rowCount,
            layCount: layCount,
            edition: edition,
            deterministic: deterministic,
            apprentice: apprentice,
            slippery: slippery
        )
    }
    
    public func be(apprentice: Bool) -> GameMaker {
        return GameMaker(
            colCount: colCount,
            rowCount: rowCount,
            layCount: layCount,
            edition: edition,
            deterministic: deterministic,
            apprentice: apprentice,
            slippery: slippery
        )
    }
    
    public func be(slippery: Bool) -> GameMaker {
        return GameMaker(
            colCount: colCount,
            rowCount: rowCount,
            layCount: layCount,
            edition: edition,
            deterministic: deterministic,
            apprentice: apprentice,
            slippery: slippery
        )
    }
    
    public func makeGame() -> Game {
        var maker = edition.maker(deterministic: deterministic)
        var tiles = Tiles(
            colCount: colCount,
            rowCount: rowCount,
            layCount: layCount
        )
        var deck = TilesDeck(
            mixer: AnyMixer(maker.makeMixer()),
            lottery: AnyLottery(maker.makeLottery())
        )
        let dealer = maker.makeDealer()
        for index in dealer.part(tiles.indices) {
            tiles[index] = deck.tile
            deck = deck.next(maxValue: 0)
        }
        let area = TilesArea(
            tiles: tiles,
            dealer: AnyDealer(dealer.next()),
            merger: AnyMerger(maker.makeMerger())
        )
        return Game(
            maker: self,
            deck: deck,
            area: area
        )
    }
}
