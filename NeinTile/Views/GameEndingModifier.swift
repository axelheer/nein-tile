import SwiftUI

struct GameEndingModifier: ViewModifier {
    @Environment (\.colorScheme) var colorScheme
    
    @EnvironmentObject var game: GameEnvironment
    
    @State private var tileSize: CGFloat = 0
    
    var overlay: Color {
        colorScheme == .dark ? .black : .white
    }
    
    func body(content: Content) -> some View {
        return ZStack {
            content
                .onPreferenceChange(TileSizePreferenceKey.self) { size in
                    self.tileSize = size
                }
            if game.current.done {
                overlay
                    .opacity(0.8)
                    .transition(AnyTransition.opacity.combined(with: .scale))
                Text("The\nEnd.")
                    .font(.system(size: tileSize, weight: .heavy))
                    .transition(AnyTransition.opacity.combined(with: .slide))
            }
        }
    }
}

extension View {
    func applyGameEnding() -> some View {
        return self.modifier(GameEndingModifier())
    }
}

#if DEBUG
struct GameEndingModifier_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            AreaView()
                .applyGameEnding()
                .preferredColorScheme(.dark)
            AreaView()
                .applyGameEnding()
                .preferredColorScheme(.light)
        }
        .accentColor(Color.orange)
        .previewLayout(.fixed(width: 400, height: 400))
        .environmentObject(GameEnvironment())
    }
}
#endif
