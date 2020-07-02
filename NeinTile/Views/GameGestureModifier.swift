import SwiftUI
import TileKit

struct GameGestureModifier: ViewModifier {
    @EnvironmentObject var game: GameEnvironment
    
    @State private var moveTo: MoveDirection?
    @State private var tileSize: CGFloat = 0
    @State private var sampleIndex: Int = 0
    
    let onFinish: (GameInfo) -> Void
   
    var swipe: some Gesture {
        DragGesture()
            .onChanged { value in
                let (dragBy, direction) = self.mapDirection(
                    dragBy: value.translation
                )
                self.showGesture(
                    dragBy: dragBy,
                    to: direction
                )
            }
            .onEnded { value in
                let (dragBy, direction) = self.mapDirection(
                    dragBy: value.predictedEndTranslation
                )
                self.applyGesture(
                    dragBy: dragBy,
                    to: direction
                )
            }
    }
    
    var pinch: some Gesture {
        MagnificationGesture()
            .onChanged { value in
                let (magnifyBy, direction) = self.mapDirection(
                    magnifyBy: value
                )
                self.showGesture(
                    magnifyBy: magnifyBy,
                    to: direction
                )
            }
            .onEnded { value in
                let (magnifyBy, direction) = self.mapDirection(
                    magnifyBy: value
                )
                self.applyGesture(
                    magnifyBy: magnifyBy,
                    to: direction
                )
        }
    }
    
    func showGesture(dragBy: CGSize = .zero, magnifyBy: CGFloat = 1, to direction: MoveDirection) {
        if moveTo != direction {
            game.preview = game.current.view(
                to: direction
            )
            moveTo = direction
        }
        game.dragBy = dragBy
        game.magnifyBy = magnifyBy
    }
    
    func applyGesture(dragBy: CGSize = .zero, magnifyBy: CGFloat = 1, to direction: MoveDirection) {
        let move = max(abs(dragBy.width), abs(dragBy.height)) == tileSize
            || magnifyBy == 0.5 || magnifyBy == 2.0
        
        if moveTo != direction {
            game.preview = game.current.view(
                to: direction
            )
            moveTo = direction
        }
        
        if move {
            let next = game.current.move(to: direction)
            if game.current.done != next.done {
                onFinish(next)
            }
            if let preview = game.preview {
                game.current = preview
                game.preview = nil
            }
            game.dragBy = .zero
            game.magnifyBy = 1
            withAnimation(.easeIn) {
                game.current = next
            }
        } else {
            withAnimation(.easeOut) {
                game.dragBy = .zero
                game.magnifyBy = 1
            }
            game.preview = nil
        }
        
        moveTo = nil
    }
    
    func body(content: Content) -> some View {
        return content
            .onPreferenceChange(TileSizePreferenceKey.self) { size in
                self.tileSize = size
            }
            .onReceive(AppNotifications.controller.publisher(), perform: handleController)
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
            let next = game.current.move(to: direction)
            if game.current.done != next.done {
                onFinish(next)
            }
            withAnimation {
                game.current = next
            }
        case .layer(let layer):
            if (layer < game.current.area.tiles.layCount) {
                withAnimation {
                    game.layer = layer
                }
            }
        case .undo:
            if let last = game.current.last {
                withAnimation {
                    game.current = last
                }
            }
        case .nextSample:
            game.current = GameSamples.allSamples[sampleIndex]
            game.layer = game.current.area.tiles.layCount - 1
            
            sampleIndex = (sampleIndex + 1) % GameSamples.allSamples.count
        }
    }
    
    func mapDirection(dragBy: CGSize) -> (CGSize, MoveDirection) {
        let direction = moveTo ?? (
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
        let direction = moveTo ?? (magnifyBy > 1 ? .front : .back)
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
    func applyGameGestures(onFinish: @escaping (GameInfo) -> Void) -> some View {
        return self.modifier(GameGestureModifier(onFinish: onFinish))
    }
}
