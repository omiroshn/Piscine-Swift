/***************************************************************************/
/*                           My Tests                                      */
/***************************************************************************/

var card1 = Card(withColor: Color.Clubs, withValue: Value.Ace)
var card2 = Card(withColor: Color.Clubs, withValue: Value.Eight)
print("Description of card1: \(card1.description)")
print("Description of card2: \(card2.description)")
print("Card1 == Card1? \(card1 == card1)")
print("Card1 == Card2? \(card1 == card2)")
print("Card1 isEqual Card1? \(card1.isEqual(card1))")
print("Card1 isEqual initParams of Card1? \(card1.isEqual(Card(withColor: Color.Clubs, withValue: Value.Ace)))")
print("Card1 isEqual Card2? \(card1.isEqual(card2))")
print("Card1 isEqual random obj? \(card1.isEqual("Hi"))")
