import Foundation

public final class Game: Codable, Identifiable {
    public let id: UUID
    public let maker: GameMaker
    
    public let deck: TilesDeck
    public let area: TilesArea

    public var move: MoveDirection? = nil
    public var last: Game? = nil
    
    private var readOnly: Bool = false
    
    public init(maker: GameMaker, deck: TilesDeck, area: TilesArea) {
        self.id = UUID()
        self.maker = maker
        
        self.deck = deck
        self.area = area
    }
    
    private init(id: UUID, maker: GameMaker, deck: TilesDeck, area: TilesArea, move: MoveDirection?, last: Game?, readOnly: Bool) {
        self.id = id
        self.maker = maker
        
        self.deck = deck
        self.area = area
        
        self.move = move
        self.last = last
        
        self.readOnly = readOnly
    }
    
    public var done: Bool {
        return MoveDirection.allCases.allSatisfy { direction in
            !area.canMove(to: direction)
        }
    }
    
    public var score: Int {
        return area.tiles.totalScore
    }
    
    public func view(to direction: MoveDirection) -> Game? {
        if !readOnly && area.canMove(to: direction) {
            let nextArea = area.move(
                to: direction,
                slippery: maker.slippery,
                nextTile: .empty
            )
            return Game(
                id: id,
                maker: maker,
                deck: deck,
                area: nextArea,
                move: direction,
                last: self,
                readOnly: true
            )
        }
        return nil
    }
    
    public func move(to direction: MoveDirection) -> Game {
        if !readOnly && area.canMove(to: direction) {
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
                last: maker.apprentice ? self : nil,
                readOnly: false
            )
        }
        return self
    }
    
    private enum CodingKeys: String, CodingKey {
        case id
        case maker
        case deck
        case area
    }
}
