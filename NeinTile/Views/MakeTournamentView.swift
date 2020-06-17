import SwiftUI

struct MakeTournamentGameView: View {
    @Binding var tournament: Tournament
    
    var onStart: () -> Void
    
    private let tournamentExplanation = "Choosing a predefined rule set makes it possible to compare the results with those of your friends and enemies. If your quest is reaching eternal glory, your path may start right here."
    
    private let tournamentNote = "Note: these games have no 'undo' button; thus, the apprentice mode is disabled. After ending a game the results are reported to the Game Center, if logged in."
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Rule set"), footer: Text(tournamentExplanation)) {
                    Picker(selection: $tournament, label: EmptyView()) {
                        ForEach(Tournament.allCases, id: \.self) {
                            Text($0.text).tag($0)
                        }
                    }
                }
                Section(footer: Text(tournamentNote)) {
                    Button(action: onStart) {
                        Text("Start tournament game")
                    }
                }
            }
            .navigationBarTitle("Tournament game")
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

extension Tournament {
    var text: String {
        let result = self.rawValue
            .replacingOccurrences(of: "_2d", with: " 2D")
            .replacingOccurrences(of: "_3d", with: " 3D")
            .replacingOccurrences(of: "_max", with: " Max")
        return result.prefix(1).uppercased() + result.dropFirst()
    }
}

#if DEBUG
struct MakeTournamentView_Previews: PreviewProvider {
    @State static var tournament: Tournament = .simple_2d
    
    static var previews: some View {
        Group {
            MakeTournamentGameView(
                tournament: $tournament,
                onStart: { }
            )
            .preferredColorScheme(.dark)
            MakeTournamentGameView(
                tournament: $tournament,
                onStart: { }
            )
            .preferredColorScheme(.light)
        }
    }
}
#endif
