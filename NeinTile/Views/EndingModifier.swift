import SwiftUI

struct EndingModifier: ViewModifier {
    @Environment (\.colorScheme) var colorScheme

    @EnvironmentObject var game: GameEnvironment

    @State private var baseSize: CGFloat = 0

    var overlay: Color {
        colorScheme == .dark ? .black : .white
    }

    func body(content: Content) -> some View {
        return ZStack {
            content
                .onPreferenceChange(TileSizePreferenceKey.self) { size in
                    let colCount = self.game.current.area.tiles.colCount
                    let rowCount = self.game.current.area.tiles.rowCount

                    self.baseSize = max(CGFloat(colCount) * size, CGFloat(rowCount) * size) / 4
                }
            if game.current.done {
                overlay
                    .opacity(0.8)
                    .transition(AnyTransition.opacity.combined(with: .scale))
                    .animation(.easeOut(duration: 1.0))
                Text("The")
                    .offset(x: 0, y: -baseSize)
                    .font(.system(size: baseSize, weight: .heavy))
                    .transition(AnyTransition.move(edge: .leading).combined(with: .opacity))
                    .animation(.easeOut(duration: 1.0))
                Text("End")
                    .font(.system(size: baseSize, weight: .heavy))
                    .transition(AnyTransition.move(edge: .trailing).combined(with: .opacity))
                    .animation(.easeOut(duration: 1.0))
                Text("Ready for the next game?")
                    .offset(x: 0, y: baseSize)
                    .multilineTextAlignment(.center)
                    .font(.system(size: baseSize / 4, weight: .bold))
                    .transition(AnyTransition.move(edge: .bottom).combined(with: .opacity))
                    .animation(.easeOut(duration: 3.0))
            }
        }
    }
}

extension View {
    func applyEnding() -> some View {
        return self.modifier(EndingModifier())
    }
}

#if DEBUG
struct GameEndingModifier_Previews: PreviewProvider {
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
