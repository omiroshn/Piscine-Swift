import Foundation

class Deck: NSObject {
    static let allSpades : [Card] = Value.allValues.map({Card(withColor: Color.Spades, withValue: $0)})
    static let allDiamonds : [Card] = Value.allValues.map({Card(withColor: Color.Diamonds, withValue: $0)})
    static let allHearts : [Card] = Value.allValues.map({Card(withColor: Color.Hearts, withValue: $0)})
    static let allClubs : [Card] = Value.allValues.map({Card(withColor: Color.Clubs, withValue: $0)})
    static let allCards : [Card] = allSpades + allDiamonds + allHearts + allClubs
}