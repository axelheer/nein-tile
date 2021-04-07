import SwiftUI
import TileKit

struct TileView: View {
    @Environment (\.colorScheme) var colorScheme

    var edge: CGFloat = 0
    var size: CGFloat = 80
    var tile: Tile

    var shadow: Color {
        colorScheme == .dark ? .black : .white
    }

    var body: some View {
        RoundedRectangle(cornerRadius: max(edge, size / 8))
            .fill(color(tile))
            .frame(
                width: size - size / 8,
                height: size - size / 8
            )
            .shadow(
                color: shadow,
                radius: size / 32
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
            return Color.clear
        }
        return tile.value != 0
            ? Color.black
            : Color.white
    }

    func color(_ tile: Tile) -> Color {
        guard tile != .empty else {
            return Color.clear
        }
        let value = tile.value != 0
            ? tile.value.magnitude - 1
            : 0
        let grade = value.bitWidth
            - value.leadingZeroBitCount
        let width = value.bitWidth
        return Color(
            hue: Double(grade / 3) / Double(width / 6),
            saturation: 0.5 + Double(grade % 3) / 4,
            brightness: 1.0
        )
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
        var result = Array(repeating: 0, count: 56)
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
            HStack {
                VStack {
                    TileView(tile: .empty)
                    ForEach(numbers, id: \.self) { value in
                        TileView(tile: Tile(value: value, score: 0))
                    }
                    TileView(tile: Tile(value: .max, score: 0))
                    TileView(tile: Tile(value: .min, score: 0))
                    TileView(tile: Tile(value: 0, score: 1))
                }
                VStack {
                    TileView(tile: .empty)
                    ForEach(1 ... 56, id: \.self) { value in
                        TileView(tile: Tile(value: 1 << value, score: 0))
                    }
                    TileView(tile: Tile(value: .max, score: 0))
                    TileView(tile: Tile(value: .min, score: 0))
                    TileView(tile: Tile(value: 0, score: 1))
                }
            }
            .preferredColorScheme(.dark)
            HStack {
                VStack {
                    TileView(tile: .empty)
                    ForEach(numbers, id: \.self) { value in
                        TileView(tile: Tile(value: value, score: 0))
                    }
                    TileView(tile: Tile(value: .max, score: 0))
                    TileView(tile: Tile(value: .min, score: 0))
                    TileView(tile: Tile(value: 0, score: 1))
                }
                VStack {
                    TileView(tile: .empty)
                    ForEach(1 ... 56, id: \.self) { value in
                        TileView(tile: Tile(value: 1 << value, score: 0))
                    }
                    TileView(tile: Tile(value: .max, score: 0))
                    TileView(tile: Tile(value: .min, score: 0))
                    TileView(tile: Tile(value: 0, score: 1))
                }
            }
            .preferredColorScheme(.light)
        }
        .previewLayout(.sizeThatFits)
    }
}
#endif
