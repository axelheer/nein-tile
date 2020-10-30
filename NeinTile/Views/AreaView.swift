import SwiftUI
import TileKit

// swiftlint:disable large_tuple function_body_length

struct AreaView: View {
    @EnvironmentObject var game: GameEnvironment

    var body: some View {
        GeometryReader { geometry in
            self.makeBody(container: geometry.size)
        }
    }

    func makeBody(container: CGSize) -> some View {
        let colCount = game.current.area.tiles.colCount
        let rowCount = game.current.area.tiles.rowCount

        let size = min(
            container.width / CGFloat(colCount),
            container.height / CGFloat(rowCount)
        )

        let columns = 0 ..< colCount
        let rows = (0 ..< rowCount).reversed()

        let index: (Int) -> Double = game.dragBy.width > 0
            ? { col in -Double(col) }
            : { col in Double(col) }

        let hInset = (container.width - size * CGFloat(colCount)) / 2
        let vInset = (container.height - size * CGFloat(rowCount)) / 2

        return ZStack {
            HStack(spacing: 0) {
                ForEach(columns, id: \.self) { _ in
                    VStack(spacing: 0) {
                        ForEach(rows, id: \.self) { _ in
                            Circle()
                                .stroke(Color.gray, style: .init(dash: [1, 3]))
                                .opacity(0.5)
                                .padding(size / 8)
                                .frame(width: size, height: size)
                        }
                    }
                }
            }
            HStack(spacing: 0) {
                ForEach(columns, id: \.self) { col in
                    VStack(spacing: 0) {
                        ForEach(rows, id: \.self) { row in
                            self.makeTile(col, row, size)
                        }
                    }
                    .zIndex(index(col))
                }
            }
            HStack(spacing: 0) {
                ForEach(columns, id: \.self) { col in
                    VStack(spacing: 0) {
                        ForEach(rows, id: \.self) { row in
                            self.makeNextTile(col, row, size)
                        }
                    }
                }
            }
            .animation(nil)
        }
        .padding(
            EdgeInsets(
                top: vInset,
                leading: hInset,
                bottom: vInset,
                trailing: hInset
            )
        )
        .preference(key: TileSizePreferenceKey.self, value: size)
    }

    func makeNextTile(_ col: Int, _ row: Int, _ size: CGFloat) -> some View {
        let next = game.next.area.tiles[col, row, game.layer]

        let opacity = nextEffect(col, row, size)

        return TileView(size: size, tile: next)
            .opacity(opacity)
    }

    func makeTile(_ col: Int, _ row: Int, _ size: CGFloat) -> some View {
        let tile = game.current.area.tiles[col, row, game.layer]

        let scale = game.next.area.tiles.getMoves(col, row, game.layer)

        let (offset, scaleEffect, opacity) = tileEffects(col, row, scale)

        return TileView(size: size, tile: tile)
            .offset(offset)
            .scaleEffect(scaleEffect)
            .opacity(opacity)
            .zIndex(Double(scale))
    }

    func nextEffect(_ col: Int, _ row: Int, _ size: CGFloat) -> Double {
        let dragPreview = (
            max(abs(game.dragBy.width),
                abs(game.dragBy.height))
            ) / size
        let magnifyPreview = game.magnifyBy > 1
            ? game.magnifyBy - 1
            : (1 - game.magnifyBy) / 0.5
        let opacity = Double(
            max(0, max(dragPreview, magnifyPreview) - 0.8)
            ) / 0.2
        return opacity
    }

    func tileEffects(_ col: Int, _ row: Int, _ scale: Int) -> (CGSize, CGFloat, Double) {
        let offset = CGSize(
            width: game.dragBy.width * CGFloat(scale),
            height: game.dragBy.height * CGFloat(scale)
        )
        let scaleEffect = game.magnifyBy > 1
            ? 2 - pow(2 - game.magnifyBy, CGFloat(scale))
            : pow(game.magnifyBy, CGFloat(scale))
        let opacity = game.magnifyBy > 1
            ? pow(Double(2 - game.magnifyBy), Double(scale))
            : pow(Double(game.magnifyBy * 2 - 1), Double(scale))
        return (offset, scaleEffect, opacity)
    }
}

struct TileSizePreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0

    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

#if DEBUG
struct TilesView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ForEach(GameSamples.allSamples) { sample in
                AreaView()
                    .environmentObject(GameEnvironment(sample))
                    .preferredColorScheme(.dark)
                AreaView()
                    .environmentObject(GameEnvironment(sample))
                    .preferredColorScheme(.light)
            }
        }
        .accentColor(Color.orange)
        .previewLayout(.fixed(width: 400, height: 400))
    }
}
#endif
