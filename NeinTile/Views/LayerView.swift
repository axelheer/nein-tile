import SwiftUI

struct LayerView: View {
    @EnvironmentObject var game: GameEnvironment
    
    var body: some View {
        HStack(spacing: 0) {
            Button(action: { self.game.show(layer: self.game.layer - 1) }) {
                Image(systemName: "chevron.left")
                    .padding()
            }
            .disabled(game.layer == 0)
            Spacer()
            Text("Layer \(game.layer + 1) of \(game.current.area.tiles.layCount)")
                .frame(maxWidth: .infinity, minHeight: 60, maxHeight: 60)
            Spacer()
            Button(action: { self.game.show(layer: self.game.layer + 1) }) {
                Image(systemName: "chevron.right")
                    .padding()
            }
            .disabled(game.layer == game.current.area.tiles.layCount - 1)
        }
        .font(.headline)
    }
}

#if DEBUG
struct LayerView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            LayerView()
                .preferredColorScheme(.dark)
            LayerView()
                .preferredColorScheme(.light)
        }
        .accentColor(Color.orange)
        .previewLayout(.fixed(width: 400, height: 60))
        .environmentObject(GameEnvironment())
    }
}
#endif
