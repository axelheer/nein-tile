import SwiftUI
import TileKit

struct ShareView: View {
    var game: Game

    var body: some View {
        GeometryReader { geometry in
            self.makeBody(container: geometry.size, bounds: geometry.frame(in: .global))
        }
    }

    func makeBody(container: CGSize, bounds: CGRect) -> some View {
        let colCount = game.area.tiles.colCount
        let rowCount = game.area.tiles.rowCount

        let size = min(
            container.width / CGFloat(colCount),
            container.height / CGFloat(rowCount)
        )

        let columns = 0 ..< colCount
        let rows = (0 ..< rowCount).reversed()

        let layer = game.area.tiles.layCount - 1

        return ZStack {
            HStack(spacing: 0) {
                ForEach(columns, id: \.self) { col in
                    VStack(spacing: 0) {
                        ForEach(rows, id: \.self) { row in
                            TileView(size: size, tile: self.game.area.tiles[col, row, layer])
                        }
                    }
                }
            }
        }
        .preference(key: ShareBoundsPreferenceKey.self, value: bounds)
    }
}

struct ShareBoundsPreferenceKey: PreferenceKey {
    static var defaultValue: CGRect = .zero

    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
        value = nextValue()
    }
}

#if DEBUG
struct ShareView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ForEach(GameSamples.allSamples) { sample in
                ShareView(game: sample)
                    .preferredColorScheme(.dark)
                ShareView(game: sample)
                    .preferredColorScheme(.light)
            }
        }
        .accentColor(Color.orange)
        .previewLayout(.fixed(width: 400, height: 400))
    }
}
#endif
