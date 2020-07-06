import SwiftUI
import TileKit

struct TileView: View {
    @Environment (\.colorScheme) var colorScheme
    
    var edge: CGFloat = 0
    var size: CGFloat = 80
    var tile: Tile
    
    var body: some View {
        RoundedRectangle(cornerRadius: max(edge, size / 8))
            .fill(color(tile))
            .frame(
                width: size - size / 8,
                height: size - size / 8
            )
            .shadow(
                color: Color.primary.opacity(0.33),
                radius: size / 64
            )
            .padding(size / 16)
            .overlay(Text(tile.text)
                .font(.system(size: size / 3, weight: .heavy))
                .foregroundColor(textColor(tile))
                .minimumScaleFactor(0.4)
                .padding(size / 8)
                .lineLimit(1)
            )
    }
    
    func textColor(_ tile: Tile) -> Color {
        guard tile != .empty else {
            return Color.primary
        }
        switch tile.value {
        case 0:
            return Color.black
        case -1, 1:
            return Color.black
        case -2, 2:
            return Color.black
        case -3, 3:
            return Color.black
        default:
            return Color.primary
        }
    }
    
    func color(_ tile: Tile) -> Color {
        guard tile != .empty else {
            return Color.clear
        }
        switch tile.value {
        case 0:
            return Color.purple
        case -1, 1:
            return Color.yellow
        case -2, 2:
            return Color.orange
        case -3, 3:
            return Color.red
        default:
            return colorScheme == .dark
                ? Color(white: 0.2)
                : Color(white: 0.8)
        }
    }
}

extension Tile {
    static let format: Formatter = {
        let result = NumberFormatter()
        result.numberStyle = .decimal
        return result
    }()
    
    var text: String {
        guard self != .empty else {
            return ""
        }
        guard value != .max else {
            return "∞"
        }
        guard value != .min else {
            return "-∞"
        }
        return Tile.format.string(for: value)!
    }
}

#if DEBUG
struct TileView_Previews: PreviewProvider {
    static let numbers: [Int] = {
        var result = Array(repeating: 0, count: 64)
        for index in 0 ..< result.count {
            if index > 1 {
                result[index] = (1 << (index - 2)) * 3
            } else {
                result[index] = 1 << index
            }
        }
        return result
    }()
    
    static var previews: some View {
        Group {
            VStack {
                TileView(tile: .empty)
                TileView(tile: Tile(value: .min, score: 0))
                TileView(tile: Tile(value: 0, score: 1))
                ForEach(numbers, id: \.self) { value in
                    TileView(tile: Tile(value: value, score: 0))
                }
                TileView(tile: Tile(value: .max, score: 0))
            }
            .preferredColorScheme(.dark)
            VStack {
                TileView(tile: .empty)
                TileView(tile: Tile(value: .min, score: 0))
                TileView(tile: Tile(value: 0, score: 1))
                ForEach(numbers, id: \.self) { value in
                    TileView(tile: Tile(value: value, score: 0))
                }
                TileView(tile: Tile(value: .max, score: 0))
            }
            .preferredColorScheme(.light)
        }
        .previewLayout(.sizeThatFits)
    }
}
#endif
