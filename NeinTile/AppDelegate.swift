import TileKit
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    override var keyCommands: [UIKeyCommand]? {
        var mappings: [(String, Any, String)] = [
            ("d", "right",  "Move to the right"),
            ("a", "left",   "Move to the left"),
            ("w", "top",    "Move to the top"),
            ("s", "bottom", "Move to the bottom"),
            ("e", "front",  "Move to the front"),
            ("q", "back",   "Move to the back"),
            
            (UIKeyCommand.inputRightArrow, "right",  "Move to the right"),
            (UIKeyCommand.inputLeftArrow,  "left",   "Move to the left"),
            (UIKeyCommand.inputUpArrow,    "top",    "Move to the top"),
            (UIKeyCommand.inputDownArrow,  "bottom", "Move to the bottom"),
            (UIKeyCommand.inputPageUp,     "front",  "Move to the front"),
            (UIKeyCommand.inputPageDown,   "back",   "Move to the back"),
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
        
        var moves = mappings.map { (input, tag, title) in
            UIKeyCommand(
                title: title,
                action: #selector(handleKeyCommand(sender:)),
                input: input,
                propertyList: tag
            )
        }
        
        moves.append(
            UIKeyCommand(
                title: "",
                action: #selector(handleKeyCommand(sender:)),
                input: "z",
                modifierFlags: .command,
                propertyList: "undo"
            )
        )
        
        #if DEBUG
        
        moves.append(
            UIKeyCommand(
                title: "",
                action: #selector(handleKeyCommand(sender:)),
                input: "n",
                modifierFlags: .command,
                propertyList: "nextSample"
            )
        )
        
        #endif
        
        return moves
    }
    
    @objc func handleKeyCommand(sender: UIKeyCommand) {
        switch sender.propertyList {
        case "nextSample" as String:
            AppNotifications.controller.post(object: ControllerCommand.nextSample)
        case "undo" as String:
            AppNotifications.controller.post(object: ControllerCommand.undo)
        case "right" as String:
            AppNotifications.controller.post(object: ControllerCommand.move(.right))
        case "left" as String:
            AppNotifications.controller.post(object: ControllerCommand.move(.left))
        case "top" as String:
            AppNotifications.controller.post(object: ControllerCommand.move(.top))
        case "bottom" as String:
            AppNotifications.controller.post(object: ControllerCommand.move(.bottom))
        case "front" as String:
            AppNotifications.controller.post(object: ControllerCommand.move(.front))
        case "back" as String:
            AppNotifications.controller.post(object: ControllerCommand.move(.back))
        case let index as Int:
            AppNotifications.controller.post(object: ControllerCommand.layer(index))
        default:
            print("Unknown command: \(String(describing: sender.propertyList))")
        }
    }
}
