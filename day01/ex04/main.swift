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