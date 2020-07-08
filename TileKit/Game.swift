import Foundation

public struct Game: Codable, Identifiable {
    public let id: UUID
    public let maker: GameMaker
    
    public let deck: TilesDeck
    public let area: TilesArea
    
    private var readOnly: Bool = false
    
    public init(maker: GameMaker, deck: TilesDeck, area: TilesArea) {
        self.id = UUID()
        self.maker = maker
        
        self.deck = deck
        self.area = area
    }
    
    private init(id: UUID, maker: GameMaker, deck: TilesDeck, area: TilesArea, readOnly: Bool) {
        self.id = id
        self.maker = maker
        
        self.deck = deck
        self.area = area
        
        self.readOnly = readOnly
    }
    
    public var done: Bool {
        return MoveDirection.allCases.allSatisfy { direction in
            !area.canMove(to: direction)
        }
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
                readOnly: true
            )
        }
        return nil
    }
    
    public func move(to direction: MoveDirection) -> Game? {
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
                readOnly: false
            )
        }
        return nil
    }
    
    private enum CodingKeys: String, CodingKey {
        case id
        case maker
        case deck
        case area
    }
}
