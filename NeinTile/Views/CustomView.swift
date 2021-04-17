import SwiftUI
import TileKit

struct CustomView: View {
    @Binding var edition: GameEdition

    @Binding var colCount: Int
    @Binding var rowCount: Int
    @Binding var layCount: Int

    @Binding var deterministic: Bool
    @Binding var apprentice: Bool
    @Binding var slippery: Bool

    let onStart: () -> Void

    private let ruleExplanations = [
        GameEdition.simple: "A simple game conforms to the common 2048 game. "
            + "Starting with 2 your quest is reaching \(Tile.format.string(for: 2048)!) at least "
            + "by simply merging equal numbers together.",
        GameEdition.classic: "A classic game conforms to the one and only 'Threes!' game. "
            + "Starting with 1 and 2 your quest is reaching \(Tile.format.string(for: 12288)!) "
            + "by merging equal numbers together, while handling evadable nice 'bonus' tiles, "
            + "which turn out to be quite bothersome more often than not...",
        GameEdition.duality: "A duality game requires you to handle two simple games within one, "
            + "while 'bonus' tiles help you to double your results.",
        GameEdition.insanity: "An insanity game requires you to handle two classic games within one, "
            + "while 'bonus' tiles play havoc with your efforts.",
        GameEdition.fibonacci: "A fibonacci game represents a nice variety using this famous sequence. "
            + "Although the rules are mostly simple, your brain may need some practice "
            + "in order to handle it properly...",
        GameEdition.unlimited: "An unlimited game provides, well, no limits (and no gains either)."
    ]

    private let dimensionsExplanation = "A game can be a cube with up to 12x12x12 sides, "
        + "if your device can handle it. But being a cube ist not a requirement; "
        + "just try 7x5x3, if you like. Beware: playing with only one layer may be a wise decision for starters..."

    private var dimensionWarning: String {
        "Can be doesn't mean should be. Handling \(Tile.format.string(for: colCount * rowCount * layCount)!) "
            + "tiles won't make it any easier. You have been warned."
    }

    private let optionsExplanation = "Playing a deterministic game means undoing and redoing one and the same move "
        + "leads to the same result, while during a non-determinstic game anything can happen. "
        + "Disabling the apprentice mode means disabling the mighty undo button means being a true number warrior. "
        + "Some like playing on a slippery surface, some prefer not; it's up to you."

    private let customNote = "Note: we have achievements! After ending a game the results are reported "
        + "to the Game Center, if logged in."

    // swiftlint:disable shorthand_operator

    var dimensionsFooter: some View {
        var result = Text(dimensionsExplanation)
        if colCount * rowCount * layCount > 100 {
            result = result + Text("\n\n")
            result = result + Text(dimensionWarning)
                .foregroundColor(Color.red)
        }
        return result
    }

    // swiftlint:enable shorthand_operator

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Rules"), footer: Text(ruleExplanations[edition]!)) {
                    Picker(selection: $edition, label: Text("Edition")) {
                        ForEach(GameEdition.allCases, id: \.self) {
                            Text($0.text).tag($0)
                        }
                    }
                }
                Section(header: Text("Dimensions"), footer: dimensionsFooter) {
                    Stepper(value: $colCount, in: 1 ... 12) {
                        Text("Columns: \(colCount)")
                    }
                    Stepper(value: $rowCount, in: 1 ... 12) {
                        Text("Rows: \(rowCount)")
                    }
                    Stepper(value: $layCount, in: 1 ... 12) {
                        Text("Layers: \(layCount)")
                    }
                }
                Section(header: Text("Options"), footer: Text(optionsExplanation)) {
                    Toggle(isOn: $deterministic) {
                        Text("Deterministic")
                    }
                    Toggle(isOn: $apprentice) {
                        Text("Apprentice")
                    }
                    Toggle(isOn: $slippery) {
                        Text("Slippery")
                    }
                }
                Section(footer: Text(customNote)) {
                    Button(action: onStart) {
                        Text("Start custom game")
                    }
                }
            }
            .navigationBarTitle("Custom game")
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

extension GameEdition {
    var text: String {
        let result = String(describing: self)
        return result.prefix(1).uppercased() + result.dropFirst()
    }
}

#if DEBUG
struct MakeCustomGameView_Previews: PreviewProvider {
    @State static var edition: GameEdition = .simple

    @State static var colCount: Int = 4
    @State static var rowCount: Int = 4
    @State static var layCount: Int = 4

    @State static var deterministic: Bool = true
    @State static var apprentice: Bool = true
    @State static var slippery: Bool = false

    static var previews: some View {
        Group {
            CustomView(
                edition: $edition,
                colCount: $colCount,
                rowCount: $rowCount,
                layCount: $layCount,
                deterministic: $deterministic,
                apprentice: $apprentice,
                slippery: $slippery,
                onStart: { }
            )
            .preferredColorScheme(.dark)
            CustomView(
                edition: $edition,
                colCount: $colCount,
                rowCount: $rowCount,
                layCount: $layCount,
                deterministic: $deterministic,
                apprentice: $apprentice,
                slippery: $slippery,
                onStart: { }
            )
            .preferredColorScheme(.light)
        }
    }
}
#endif
