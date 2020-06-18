public struct GameMaker {
    public let custom: Maker?
    
    public let colCount: Int
    public let rowCount: Int
    public let layCount: Int
    
    public let edition: GameEdition
    
    public let deterministic: Bool
    public let apprentice: Bool
    public let slippery: Bool
    
    public init() {
        self.init(
            custom: nil,
            colCount: 4,
            rowCount: 4,
            layCount: 1,
            edition: .simple,
            deterministic: true,
            apprentice: true,
            slippery: true
        )
    }
    
    private init(custom: Maker?, colCount: Int, rowCount: Int, layCount: Int, edition: GameEdition, deterministic: Bool, apprentice: Bool, slippery: Bool) {
        self.custom = custom
        self.colCount = colCount
        self.rowCount = rowCount
        self.layCount = layCount
        self.edition = edition
        self.deterministic = deterministic
        self.apprentice = apprentice
        self.slippery = slippery
    }
    
    public func use(custom: Maker) -> GameMaker {
        return GameMaker(
            custom: custom,
            colCount: colCount,
            rowCount: rowCount,
            layCount: layCount,
            edition: edition,
            deterministic: deterministic,
            apprentice: apprentice,
            slippery: slippery
        )
    }
    
    public func use(colCount: Int, rowCount: Int, layCount: Int = 1) -> GameMaker {
        precondition(colCount > 0, "Count out of range")
        precondition(rowCount > 0, "Count out of range")
        precondition(layCount > 0, "Count out of range")
        
        return GameMaker(
            custom: custom,
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
            custom: custom,
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
            custom: custom,
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
            custom: custom,
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
            custom: custom,
            colCount: colCount,
            rowCount: rowCount,
            layCount: layCount,
            edition: edition,
            deterministic: deterministic,
            apprentice: apprentice,
            slippery: slippery
        )
    }
    
    public func makeGame() -> GameInfo {
        let maker = custom ?? edition.maker(deterministic: deterministic)
        var tiles = Tiles(
            colCount: colCount,
            rowCount: rowCount,
            layCount: layCount
        )
        var deck = TilesDeck(
            mixer: maker.makeMixer(),
            lottery: maker.makeLottery()
        )
        let dealer = maker.makeDealer()
        for index in dealer.part(tiles.indices) {
            tiles[index] = deck.tile
            deck = deck.next(maxValue: 0)
        }
        let area = TilesArea(
            tiles: tiles,
            dealer: dealer.next(),
            merger: maker.makeMerger()
        )
        return Game(
            deck: deck,
            area: area,
            apprentice: apprentice,
            slippery: slippery
        )
    }
}
