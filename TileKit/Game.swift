import Foundation

internal final class Game: GameInfo {
    public override func view(to direction: MoveDirection) -> GameInfo? {
        if area.canMove(to: direction) {
            let nextArea = area.move(
                to: direction,
                slippery: maker.slippery,
                nextTile: .empty
            )
            return GameInfo(
                id: id,
                maker: maker,
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
                slippery: maker.slippery,
                nextTile: deck.tile
            )
            let nextDeck = deck.next(
                maxValue: nextArea.tiles.maxValue
            )
            return Game(
                id: id,
                maker: maker,
                deck: nextDeck,
                area: nextArea,
                move: maker.apprentice ? direction : nil,
                last: maker.apprentice ? self : nil
            )
        }
        return self
    }
}

public class GameInfo: Identifiable {
    public let id: UUID
    public let maker: GameMaker
    
    public let deck: TilesDeck
    public let area: TilesArea

    public let move: MoveDirection?
    public let last: GameInfo?
    
    public init(maker: GameMaker, deck: TilesDeck, area: TilesArea) {
        self.id = UUID()
        self.maker = maker
        
        self.deck = deck
        self.area = area
        
        self.move = nil
        self.last = nil
    }
    
    fileprivate init(id: UUID, maker: GameMaker, deck: TilesDeck, area: TilesArea, move: MoveDirection?, last: GameInfo?) {
        self.id = id
        self.maker = maker
        
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
