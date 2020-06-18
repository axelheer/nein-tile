import Foundation

internal final class Game: GameInfo {
    public let apprentice: Bool
    public let slippery: Bool
    
    public init(deck: TilesDeck, area: TilesArea, apprentice: Bool, slippery: Bool) {
        self.apprentice = apprentice
        self.slippery = slippery
        
        super.init(deck: deck, area: area)
    }
    
    private init(id: UUID, deck: TilesDeck, area: TilesArea, apprentice: Bool, slippery: Bool, move: MoveDirection?, last: Game?) {
        self.apprentice = apprentice
        self.slippery = slippery
        
        super.init(id: id, deck: deck, area: area, move: move, last: last)
    }
    
    public override func view(to direction: MoveDirection) -> GameInfo? {
        if area.canMove(to: direction) {
            let nextArea = area.move(
                to: direction,
                slippery: slippery,
                nextTile: .empty
            )
            return GameInfo(
                id: id,
                deck: deck,
                area: nextArea,
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
                id: id,
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

public class GameInfo: Identifiable {
    public let id: UUID
    
    public let deck: TilesDeck
    public let area: TilesArea

    public let move: MoveDirection?
    public let last: GameInfo?
    
    public init(deck: TilesDeck, area: TilesArea) {
        self.deck = deck
        self.area = area
        
        self.move = nil
        self.last = nil
        
        id = UUID()
    }
    
    fileprivate init(id: UUID, deck: TilesDeck, area: TilesArea, move: MoveDirection?, last: GameInfo?) {
        self.id = id
        
        self.deck = deck
        self.area = area
        
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
