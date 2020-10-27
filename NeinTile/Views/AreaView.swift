import SwiftUI
import TileKit

// swiftlint:disable large_tuple

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

        let hInset = (container.width - size * CGFloat(colCount)) / 2
        let vInset = (container.height - size * CGFloat(rowCount)) / 2

        let columns = 0 ..< colCount
        let rows = (0 ..< rowCount).reversed()

        let index: (Int) -> Double = game.dragBy.width > 0
            ? { col in -Double(col) }
            : { col in Double(col) }

        return HStack(spacing: 0) {
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
        }.overlay(HStack(spacing: 0) {
            ForEach(columns, id: \.self) { col in
                VStack(spacing: 0) {
                    ForEach(rows, id: \.self) { row in
                        self.makeTile(col, row, size)
                    }
                }
                .zIndex(index(col))
            }
        })
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

    func makeTile(_ col: Int, _ row: Int, _ size: CGFloat) -> some View {
        let finish = nextEffect(col, row, size)

        let tile = finish < 1.0
            ? game.current.area.tiles[col, row, game.layer]
            : game.next.area.tiles[col, row, game.layer]

        let scale = finish < 1.0
            ? game.next.area.tiles.getMoves(col, row, game.layer)
            : 0

        let (offset, scaleEffect, opacity) = tileEffects(col, row, scale)

        return TileView(size: size, tile: tile)
            .offset(offset)
            .scaleEffect(scaleEffect)
            .opacity(opacity)
            .zIndex(Double(scale))
    }

    func nextEffect(_ col: Int, _ row: Int, _ size: CGFloat) -> CGFloat {
        let dragPreview = (
            max(abs(game.dragBy.width),
                abs(game.dragBy.height))
            ) / size
        let magnifyPreview = game.magnifyBy > 1
            ? game.magnifyBy - 1
            : (1 - game.magnifyBy) / 0.5
        return max(dragPreview, magnifyPreview)
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
