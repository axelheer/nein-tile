// swiftlint:disable identifier_name cyclomatic_complexity function_body_length

public struct HaraldMerger: Merger {
    public init() {
    }

    public func canMerge(_ source: Tile, _ target: Tile) -> Bool {
        switch (source.value, target.value) {
        case (0, _):
            return false
        case (_, 0):
            return true
        case (789790, _):
            return false
        case (_, 789790):
            return false
        case let (x, y):
            return x == y
        }
    }

    public func merge(_ source: Tile, _ target: Tile) -> Tile {
        assert(canMerge(source, target), "Cannot merge")

        switch (target.value, source, target) {
        case let (90, x, y):
            return Tile(
                value: 110,
                score: x.score |+ y.score |+ 330
            )
        case let (110, x, y):
            return Tile(
                value: 270,
                score: x.score |+ y.score |+ 810
            )
        case let (270, x, y):
            return Tile(
                value: 380,
                score: x.score |+ y.score |+ 1140
            )
        case let (380, x, y):
            return Tile(
                value: 540,
                score: x.score |+ y.score |+ 1620
            )
        case let (540, x, y):
            return Tile(
                value: 630,
                score: x.score |+ y.score |+ 1890
            )
        case let (630, x, y):
            return Tile(
                value: 1010,
                score: x.score |+ y.score |+ 3030
            )
        case let (1010, x, y):
            return Tile(
                value: 1120,
                score: x.score |+ y.score |+ 3360
            )
        case let (1120, x, y):
            return Tile(
                value: 1590,
                score: x.score |+ y.score |+ 4770
            )
        case let (1590, x, y):
            return Tile(
                value: 2600,
                score: x.score |+ y.score |+ 7800
            )
        case let (2600, x, y):
            return Tile(
                value: 3790,
                score: x.score |+ y.score |+ 11370
            )
        case let (3790, x, y):
            return Tile(
                value: 4770,
                score: x.score |+ y.score |+ 14310
            )
        case let (4770, x, y):
            return Tile(
                value: 7370,
                score: x.score |+ y.score |+ 22110
            )
        case let (7370, x, y):
            return Tile(
                value: 12140,
                score: x.score |+ y.score |+ 36420
            )
        case let (12140, x, y):
            return Tile(
                value: 17890,
                score: x.score |+ y.score |+ 53670
            )
        case let (17890, x, y):
            return Tile(
                value: 25260,
                score: x.score |+ y.score |+ 75780
            )
        case let (25260, x, y):
            return Tile(
                value: 40520,
                score: x.score |+ y.score |+ 121560
            )
        case let (40520, x, y):
            return Tile(
                value: 58930,
                score: x.score |+ y.score |+ 176790
            )
        case let (58930, x, y):
            return Tile(
                value: 84190,
                score: x.score |+ y.score |+ 252570
            )
        case let (84190, x, y):
            return Tile(
                value: 117340,
                score: x.score |+ y.score |+ 352020
            )
        case let (117340, x, y):
            return Tile(
                value: 136270,
                score: x.score |+ y.score |+ 408810
            )
        case let (136270, x, y):
            return Tile(
                value: 157860,
                score: x.score |+ y.score |+ 473580
            )
        case let (157860, x, y):
            return Tile(
                value: 235200,
                score: x.score |+ y.score |+ 705600
            )
        case let (235200, x, y):
            return Tile(
                value: 319390,
                score: x.score |+ y.score |+ 958170
            )
        case let (319390, x, y):
            return Tile(
                value: 418320,
                score: x.score |+ y.score |+ 1254960
            )
        case let (418320, x, y):
            return Tile(
                value: 554590,
                score: x.score |+ y.score |+ 1663770
            )
        case let (554590, x, y):
            return Tile(
                value: 789790,
                score: x.score |+ y.score |+ 2369370
            )
        default:
            return source
        }
    }
}
