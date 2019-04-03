import UIKit

enum Color: String {
    case Spades = "♠"
    case Hearts = "♥"
    case Diamonds = "♦"
    case Clubs = "♣"
    static let allColors: [Color] = [Spades, Hearts, Diamonds, Clubs]
}

enum Value: Int {
    case Ace = 1, Two, Three, Four, Five, Six, Seven, Eight, Nine, Ten, Jack, Queen, King
    static let allValues: [Value] = [Ace, Two, Three, Four, Five, Six, Seven, Eight, Nine, Ten, Jack, Queen, King]
}

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

class Deck: NSObject {
    static let allSpades : [Card] = Value.allValues.map({Card(withColor: Color.Spades, withValue: $0)})
    static let allDiamonds : [Card] = Value.allValues.map({Card(withColor: Color.Diamonds, withValue: $0)})
    static let allHearts : [Card] = Value.allValues.map({Card(withColor: Color.Hearts, withValue: $0)})
    static let allClubs : [Card] = Value.allValues.map({Card(withColor: Color.Clubs, withValue: $0)})
    static let allCards : [Card] = allSpades + allDiamonds + allHearts + allClubs
    
    var cards : [Card]
    var discards : [Card]
    var outs : [Card]
    
    init(hasToBeSortedOrMixed flag: Bool) {
        self.cards = flag == true ? Deck.allCards.shuffle() : Deck.allCards
        self.discards = []
        self.outs = []
    }
    
    override var description: String {
        var str: String = ""
        self.cards.map({str += "\($0.description)\n"})
        return str
    }
    
    func draw() -> Card? {
        if let card = self.cards.first {
            self.cards.removeFirst()
            self.outs.append(card)
            return card
        } else {
            return nil
        }
    }
    
    func fold(_ card : Card) {
        if self.outs.contains(card) {
            if let itemToRemoveIndex = self.outs.firstIndex(of: card) {
                self.outs.remove(at: itemToRemoveIndex)
            }
            self.discards.append(card)
        }
    }
    
}

extension Array {
    func shuffle() -> Array {
        var items = self
        var shuffled: Array = [];
        
        for _ in 0..<items.count {
            let rand = Int(arc4random_uniform(UInt32(items.count)))
            shuffled.append(items[rand])
            items.remove(at: rand)
        }
        return shuffled
    }
}

/***************************************************************************/
/*                           My Tests                                      */
/***************************************************************************/

var deck = Deck(hasToBeSortedOrMixed: false) //change to true
print(deck.description)
if let card = deck.draw() {
    print("Picked card: \(card)")
    print("Outs: \(deck.outs)")
    deck.fold(card)
    print("Removed this card from outs.. Added to discards")
    print("Outs: \(deck.outs)")
    print("Discards: \(deck.discards)")
}
print("Deck:")
print(deck)
