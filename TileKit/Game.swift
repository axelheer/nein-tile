public final class Game: GameInfo {
    internal override init(deck: TilesDeck, area: TilesArea, apprentice: Bool, slippery: Bool) {
        super.init(deck: deck, area: area, apprentice: apprentice, slippery: slippery)
    }
    
    private override init(deck: TilesDeck, area: TilesArea, apprentice: Bool, slippery: Bool, move: MoveDirection?, last: Game?) {
        super.init(deck: deck, area: area, apprentice: apprentice, slippery: slippery, move: move, last: last)
    }
    
    public override func view(to direction: MoveDirection) -> GameInfo? {
        if area.canMove(to: direction) {
            let nextArea = area.move(
                to: direction,
                slippery: slippery,
                nextTile: .empty
            )
            return GameInfo(
                deck: deck,
                area: nextArea,
                apprentice: apprentice,
                slippery: slippery,
                move: direction,
                last: self
            )
        }
        return nil
    }
    
    public override func move(to direction: MoveDirection) -> GameInfo {
        if area.canMove(to: direction) {
            let nextArea = area.move(
                to: direction,
                slippery: slippery,
                nextTile: deck.tile
            )
            let nextDeck = deck.next(
                maxValue: nextArea.tiles.maxValue
            )
            return Game(
                deck: nextDeck,
                area: nextArea,
                apprentice: apprentice,
                slippery: slippery,
                move: apprentice ? direction : nil,
                last: apprentice ? self : nil
            )
        }
        return self
    }
}

public class GameInfo {
    public let deck: TilesDeck
    public let area: TilesArea
    
    public let apprentice: Bool
    public let slippery: Bool

    public let move: MoveDirection?
    public let last: Game?
    
    public init(deck: TilesDeck, area: TilesArea, apprentice: Bool, slippery: Bool) {
        self.deck = deck
        self.area = area
        
        self.apprentice = apprentice
        self.slippery = slippery
        
        self.move = nil
        self.last = nil
    }
    
    internal init(deck: TilesDeck, area: TilesArea, apprentice: Bool, slippery: Bool, move: MoveDirection?, last: Game?) {
        self.deck = deck
        self.area = area
        
        self.apprentice = apprentice
        self.slippery = slippery
        
        self.move = move
        self.last = last
    }
    
    public var done: Bool {
        return MoveDirection.allCases.allSatisfy { direction in
            !area.canMove(to: direction)
        }
    }
    
    public var score: Int {
        return area.tiles.totalScore
    }
    
    public func view(to direction: MoveDirection) -> GameInfo? {
        return nil
    }
    
    public func move(to direction: MoveDirection) -> GameInfo {
        return self
    }
}
