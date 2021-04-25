import Foundation

// swiftlint:disable identifier_name

public struct Game: Codable, Identifiable {
    public let id: UUID
    public let maker: GameMaker

    public let deck: TilesDeck
    public let area: TilesArea

    public let readOnly: Bool

    public init(maker: GameMaker, deck: TilesDeck, area: TilesArea) {
        self.id = UUID()
        self.maker = maker

        self.deck = deck
        self.area = area

        self.readOnly = false
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
                slippery: maker.slippery
            ) {
                .empty
            }
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
            var moveDeck = deck // state necessary?
            let nextArea = area.move(
                to: direction,
                slippery: maker.slippery
            ) {
                let nextTile = moveDeck.tile
                moveDeck = moveDeck.next(
                    maxValue: area.tiles.maxValue
                )
                return nextTile
            }
            let nextDeck = moveDeck.next(
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

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(UUID.self, forKey: .id)
        maker = try container.decode(GameMaker.self, forKey: .maker)

        deck = try container.decode(TilesDeck.self, forKey: .deck)
        area = try container.decode(TilesArea.self, forKey: .area)

        readOnly = false
    }

    public func encode(to encoder: Encoder) throws {
        guard !readOnly else {
            throw EncodingError.invalidValue(self, .init(
                codingPath: encoder.codingPath, debugDescription: "Read-only game"))
        }

        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(id, forKey: .id)
        try container.encode(maker, forKey: .maker)

        try container.encode(deck, forKey: .deck)
        try container.encode(area, forKey: .area)
    }
}
