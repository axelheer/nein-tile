import TileKit
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    override var keyCommands: [UIKeyCommand]? {
        var mappings: [(String, Any, String)] = [
            ("d", "right", "Move to the right"),
            ("a", "left",  "Move to the left"),
            ("w", "up",    "Move to the up"),
            ("s", "down",  "Move to the down"),
            ("e", "front", "Move to the front"),
            ("q", "back",  "Move to the back"),
            
            (UIKeyCommand.inputRightArrow, "right", "Move to the right"),
            (UIKeyCommand.inputLeftArrow,  "left",  "Move to the left"),
            (UIKeyCommand.inputUpArrow,    "up",    "Move to the up"),
            (UIKeyCommand.inputDownArrow,  "down",  "Move to the down"),
            (UIKeyCommand.inputPageUp,     "front", "Move to the front"),
            (UIKeyCommand.inputPageDown,   "back",  "Move to the back"),
        ]
        
        if #available(iOS 13.4, *) {
            mappings += [
                (UIKeyCommand.f1,  0,  "Layer 1"),
                (UIKeyCommand.f2,  1,  "Layer 2"),
                (UIKeyCommand.f3,  2,  "Layer 3"),
                (UIKeyCommand.f4,  3,  "Layer 4"),
                (UIKeyCommand.f5,  4,  "Layer 5"),
                (UIKeyCommand.f6,  5,  "Layer 6"),
                (UIKeyCommand.f7,  6,  "Layer 7"),
                (UIKeyCommand.f8,  7,  "Layer 8"),
                (UIKeyCommand.f9,  8,  "Layer 9"),
                (UIKeyCommand.f10, 9,  "Layer 10"),
                (UIKeyCommand.f11, 10, "Layer 11"),
                (UIKeyCommand.f12, 11, "Layer 12")
            ]
        }
        
        let moves = mappings.map { (input, tag, title) in
            UIKeyCommand(
                title: title,
                action: #selector(handleKeyCommand(sender:)),
                input: input,
                propertyList: tag
            )
        }
        
        let undo = UIKeyCommand(
            title: "",
            action: #selector(handleKeyCommand(sender:)),
            input: "z",
            modifierFlags: .command,
            propertyList: "undo"
        )
        
        return moves + [undo]
    }
    
    @objc func handleKeyCommand(sender: UIKeyCommand) {
        switch sender.propertyList {
        case "undo" as String:
            AppNotifications.keyCommand.post(object: KeyCommand.undo)
        case "right" as String:
            AppNotifications.keyCommand.post(object: KeyCommand.move(.right))
        case "left" as String:
            AppNotifications.keyCommand.post(object: KeyCommand.move(.left))
        case "up" as String:
            AppNotifications.keyCommand.post(object: KeyCommand.move(.up))
        case "down" as String:
            AppNotifications.keyCommand.post(object: KeyCommand.move(.down))
        case "front" as String:
            AppNotifications.keyCommand.post(object: KeyCommand.move(.front))
        case "back" as String:
            AppNotifications.keyCommand.post(object: KeyCommand.move(.back))
        case let index as Int:
            AppNotifications.keyCommand.post(object: KeyCommand.layer(index))
        default:
            print("Unknown command: \(String(describing: sender.propertyList))")
        }
    }
}
