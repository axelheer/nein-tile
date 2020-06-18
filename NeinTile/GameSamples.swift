import TileKit

#if DEBUG

struct GameSamples {
    static let allSamples: [GameInfo] = {
       return [ simple, classic, duality, insanity, fibonacci ]
    }()
    
    static let simple: GameInfo = {
        var tiles = Tiles(colCount: 4, rowCount: 4, layCount: 1)
        tiles[0, 0, 0] = Tile(value: 2, score: 0)
        tiles[1, 0, 0] = Tile(value: 8, score: 0)
        tiles[2, 0, 0] = Tile(value: 128, score: 0)
        tiles[3, 0, 0] = Tile(value: 1024, score: 0)
        tiles[2, 1, 0] = Tile(value: 8, score: 0)
        tiles[3, 1, 0] = Tile(value: 4, score: 0)
        tiles[1, 2, 0] = Tile(value: 2, score: 0)
        tiles[3, 2, 0] = Tile(value: 2, score: 0)
        
        let maker = GameEdition.simple.maker(gameOfDice: LawfulGameOfDice())
        let deck = TilesDeck(mixer: maker.makeMixer(), lottery: maker.makeLottery())
        let area = TilesArea(tiles: tiles, dealer: maker.makeDealer(), merger: maker.makeMerger())
        
        return GameInfo(deck: deck, area: area)
    }()
    
    static let classic: GameInfo = {
        var tiles = Tiles(colCount: 4, rowCount: 4, layCount: 2)
        tiles[0, 0, 1] = Tile(value: 384, score: 0)
        tiles[1, 0, 1] = Tile(value: 6, score: 0)
        tiles[2, 0, 1] = Tile(value: 1536, score: 0)
        tiles[3, 0, 1] = Tile(value: 3072, score: 0)
        tiles[0, 1, 1] = Tile(value: 6, score: 0)
        tiles[1, 1, 1] = Tile(value: 12, score: 0)
        tiles[2, 1, 1] = Tile(value: 384, score: 0)
        tiles[3, 1, 1] = Tile(value: 24, score: 0)
        tiles[0, 2, 1] = Tile(value: 1, score: 0)
        tiles[1, 2, 1] = Tile(value: 192, score: 0)
        tiles[2, 2, 1] = Tile(value: 48, score: 0)
        tiles[3, 2, 1] = Tile(value: 2, score: 0)
        tiles[0, 3, 1] = Tile(value: 3, score: 0)
        tiles[1, 3, 1] = Tile(value: 6, score: 0)
        tiles[2, 3, 1] = Tile(value: 1, score: 0)
        tiles[3, 3, 1] = Tile(value: 3, score: 0)
        
        let maker = GameEdition.classic.maker(gameOfDice: LawfulGameOfDice())
        let deck = TilesDeck(mixer: maker.makeMixer(), lottery: maker.makeLottery())
        let area = TilesArea(tiles: tiles, dealer: maker.makeDealer(), merger: maker.makeMerger())
        
        return GameInfo(deck: deck, area: area)
    }()
    
    static let duality: GameInfo = {
        var tiles = Tiles(colCount: 5, rowCount: 5, layCount: 2)
        tiles[0, 0, 1] = Tile(value: 0, score: 1)
        tiles[1, 0, 1] = Tile(value: 64, score: 0)
        tiles[2, 0, 1] = Tile(value: 0, score: 1)
        tiles[3, 0, 1] = Tile(value: 128, score: 0)
        tiles[4, 0, 1] = Tile(value: 0, score: 1)
        tiles[1, 1, 1] = Tile(value: 4, score: 0)
        tiles[2, 1, 1] = Tile(value: -8, score: 0)
        tiles[4, 1, 1] = Tile(value: 4, score: 0)
        tiles[1, 2, 1] = Tile(value: 2, score: 0)
        tiles[4, 2, 1] = Tile(value: 0, score: 1)
        tiles[4, 3, 1] = Tile(value: -2, score: 0)
        
        let maker = GameEdition.duality.maker(gameOfDice: LawfulGameOfDice())
        let deck = TilesDeck(mixer: maker.makeMixer(), lottery: maker.makeLottery())
        let area = TilesArea(tiles: tiles, dealer: maker.makeDealer(), merger: maker.makeMerger())
        
        return GameInfo(deck: deck, area: area)
    }()
    
    static let insanity: GameInfo = {
        var tiles = Tiles(colCount: 5, rowCount: 5, layCount: 2)
        tiles[1, 0, 1] = Tile(value: 6, score: 0)
        tiles[2, 0, 1] = Tile(value: -3, score: 0)
        tiles[3, 0, 1] = Tile(value: 12, score: 0)
        tiles[4, 0, 1] = Tile(value: 0, score: 1)
        tiles[2, 1, 1] = Tile(value: 0, score: 1)
        tiles[3, 1, 1] = Tile(value: 24, score: 0)
        tiles[4, 1, 1] = Tile(value: 3, score: 0)
        tiles[4, 2, 1] = Tile(value: 48, score: 0)
        tiles[0, 3, 1] = Tile(value: -2, score: 0)
        
        let maker = GameEdition.insanity.maker(gameOfDice: LawfulGameOfDice())
        let deck = TilesDeck(mixer: maker.makeMixer(), lottery: maker.makeLottery())
        let area = TilesArea(tiles: tiles, dealer: maker.makeDealer(), merger: maker.makeMerger())
        
        return GameInfo(deck: deck, area: area)
    }()
    
    static let fibonacci: GameInfo = {
        var tiles = Tiles(colCount: 6, rowCount: 6, layCount: 6)
        tiles[0, 0, 5] = Tile(value: 3, score: 0)
        tiles[1, 0, 5] = Tile(value: 21, score: 0)
        tiles[2, 0, 5] = Tile(value: 55, score: 0)
        tiles[3, 0, 5] = Tile(value: 987, score: 0)
        tiles[4, 0, 5] = Tile(value: 2584, score: 0)
        tiles[5, 0, 5] = Tile(value: 144, score: 0)
        tiles[2, 1, 5] = Tile(value: 3, score: 0)
        tiles[3, 1, 5] = Tile(value: 13, score: 0)
        tiles[4, 1, 5] = Tile(value: 2, score: 21)
        tiles[5, 1, 5] = Tile(value: 21, score: 0)
        tiles[4, 2, 5] = Tile(value: 5, score: 0)
        tiles[5, 2, 5] = Tile(value: 55, score: 0)
        tiles[5, 5, 5] = Tile(value: 1, score: 0)
        
        let maker = GameEdition.fibonacci.maker(gameOfDice: LawfulGameOfDice())
        let deck = TilesDeck(mixer: maker.makeMixer(), lottery: maker.makeLottery())
        let area = TilesArea(tiles: tiles, dealer: maker.makeDealer(), merger: maker.makeMerger())
        
        return GameInfo(deck: deck, area: area)
    }()
}

#endif
