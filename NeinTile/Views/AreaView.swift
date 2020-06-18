import SwiftUI
import TileKit

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
        
        let index: (Int) -> Double = game.preview?.move != .right
            ? { col in -Double(col) }
            : { col in Double(col) }
        
        return ZStack {
            HStack(spacing: 0) {
                ForEach(columns, id: \.self) { col in
                    VStack(spacing: 0) {
                        ForEach(rows, id: \.self) { row in
                            TileView(size: size)
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
        }
        .preference(key: TileSizePreferenceKey.self, value: size)
    }
    
    func makeTile(_ col: Int, _ row: Int, _ size: CGFloat) -> some View {
        let tile = game.current.area.tiles[col, row, game.layer]
        
        let (scale, offset, scaleEffect, opacity) = tileEffects(col, row)
        
        let (next, nextOpacity) = nextEffect(col, row, size)
        
        let factor = scale != 0 ? 1 - nextOpacity : 1
       
        return ZStack {
            TileView(size: size, tile: tile)
                .offset(offset)
                .scaleEffect(scaleEffect)
                .opacity(opacity * factor)
            if next != tile || scale != 0 {
                TileView(size: size, tile: next)
                    .opacity(nextOpacity)
            }
        }
        .zIndex(-Double(scale))
    }
    
    func nextEffect(_ col: Int, _ row: Int, _ size: CGFloat) -> (Tile, Double) {
        guard let preview = game.preview else {
            return (.empty, 0)
        }
        let next = preview.area.tiles[col, row, game.layer]
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
        return (next, opacity)
    }
    
    func tileEffects(_ col: Int, _ row: Int) -> (Int, CGSize, CGFloat, Double) {
        guard let preview = game.preview else {
            return (0, .zero, 1, 1)
        }
        let scale = preview.area.tiles.getMoves(col: col, row: row, lay: game.layer)
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
        return (scale, offset, scaleEffect, opacity)
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
