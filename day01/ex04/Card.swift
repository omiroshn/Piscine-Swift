import Foundation

class Card: NSObject {
    var color: Color
    var value: Value
    
    init(withColor color: Color, withValue value: Value) {
        self.color = color
        self.value = value
    }
    
    override var description: String {
        return "Color = \(self.color.rawValue), Value = \(self.value.rawValue)"
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        if let other = object as? Card {
            return self == other
        } else {
            return false
        }
    }
    
    static func == (lhs: Card, rhs: Card) -> Bool {
        return lhs.color == rhs.color
            && lhs.value == rhs.value
    }
}