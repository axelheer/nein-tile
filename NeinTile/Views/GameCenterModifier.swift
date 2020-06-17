import SwiftUI

struct GameCenterModifier: ViewModifier {
    @State private var showGameCenterError: Bool = false
    @State private var lastGameCenterError: String = "."
    
    func body(content: Content) -> some View {
        return content
            .alert(isPresented: $showGameCenterError) {
                Alert(
                    title: Text("Game Center"),
                    message: Text(lastGameCenterError),
                    dismissButton: .default(Text("However"))
                )
            }
            .onAppear() {
                AppNotifications.gameCenter.post(object: GameCenterCommand.authenticate)
            }
            .onReceive(AppNotifications.gameCenterError.publisher(), perform: handleGameCenterError)
    }
    
    func handleGameCenterError(notification: Notification) {
        if let error = notification.object as? Error {
            lastGameCenterError = error.localizedDescription
        } else {
            lastGameCenterError = String(describing: notification.object)
        }
        showGameCenterError = true
    }
}

extension View {
    func applyGameCenter() -> some View {
        return self.modifier(GameCenterModifier())
    }
}
