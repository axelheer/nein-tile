import SwiftUI
import TileKit

struct GestureModifier: ViewModifier {
    @Environment(\.undoManager) var undoManager

    @EnvironmentObject var game: GameEnvironment

    @State private var tileSize: CGFloat = 0
    @State private var sampleIndex: Int = 0

    var swipe: some Gesture {
        DragGesture()
            .onChanged { value in
                let (dragBy, direction) = self.mapDirection(
                    dragBy: value.translation
                )
                self.game.show(
                    dragBy: dragBy,
                    to: direction
                )
            }
            .onEnded { value in
                let (dragBy, direction) = self.mapDirection(
                    dragBy: value.predictedEndTranslation
                )
                if abs(dragBy.width) == self.tileSize || abs(dragBy.height) == self.tileSize {
                    self.game.move(to: direction, using: self.undoManager)
                } else {
                    self.game.backout()
                }
            }
    }

    var pinch: some Gesture {
        MagnificationGesture()
            .onChanged { value in
                let (magnifyBy, direction) = self.mapDirection(
                    magnifyBy: value
                )
                self.game.show(
                    magnifyBy: magnifyBy,
                    to: direction
                )
            }
            .onEnded { value in
                let (magnifyBy, direction) = self.mapDirection(
                    magnifyBy: value
                )
                if magnifyBy == 0.5 || magnifyBy == 2.0 {
                    self.game.move(to: direction, using: self.undoManager)
                } else {
                    self.game.backout()
                }
            }
    }

    func body(content: Content) -> some View {
        return content
            .onPreferenceChange(TileSizePreferenceKey.self) { size in
                self.tileSize = size
            }
            .onReceive(
                NotificationCenter.default.publisher(
                    for: .init(AppNotifications.controller.rawValue)
                ),
                perform: handleController
            )
            .contentShape(Rectangle())
            .gesture(swipe)
            .gesture(pinch)
    }

    func handleController(notification: Notification) {
        guard let command = notification.object as? ControllerCommand else {
            return
        }

        switch command {
        case .move(let direction):
            game.move(to: direction, using: undoManager)
        case .layer(let layer):
            game.show(layer: layer)
        case .undo:
            undoManager?.undo()
        case .nextSample:
            game.reset(GameSamples.allSamples[sampleIndex], using: undoManager)
            sampleIndex = (sampleIndex + 1) % GameSamples.allSamples.count
        }
    }

    func mapDirection(dragBy: CGSize) -> (CGSize, MoveDirection) {
        let direction = game.moveTo ?? (
            abs(dragBy.width) > abs(dragBy.height)
                ? (dragBy.width > 0 ? .right : .left)
                : (dragBy.height < 0 ? .top : .bottom)
        )
        switch direction {
        case .right:
            return (.init(width: max(0, min(tileSize, dragBy.width)), height: 0), .right)
        case .left:
            return (.init(width: max(-tileSize, min(0, dragBy.width)), height: 0), .left)
        case .top:
            return (.init(width: 0, height: max(-tileSize, min(0, dragBy.height))), .top)
        case .bottom:
            return (.init(width: 0, height: max(0, min(tileSize, dragBy.height))), .bottom)
        default:
            return (.zero, .right)
        }
    }

    func mapDirection(magnifyBy: CGFloat) -> (CGFloat, MoveDirection) {
        let direction = game.moveTo ?? (magnifyBy > 1 ? .front : .back)
        switch direction {
        case .front:
            return (max(1.0, min(2.0, magnifyBy)), .front)
        case .back:
            return (max(0.5, min(1.0, magnifyBy)), .back)
        default:
            return (1.0, .front)
        }
    }
}

extension View {
    func applyGestures() -> some View {
        return self.modifier(GestureModifier())
    }
}
