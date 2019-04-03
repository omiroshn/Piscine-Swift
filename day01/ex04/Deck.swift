import Foundation

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