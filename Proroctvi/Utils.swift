import Foundation

func random(maximum: Int) -> Int {
    return Int(arc4random_uniform(UInt32(maximum)))
}

extension CollectionType {
    func shuffled() -> [Generator.Element] {
        var list = Array(self)
        if list.count < 2 { return list }
        for i in 0..<list.count-1 {
            let j = random(list.count-i)+i
            if i != j {
                swap(&list[i], &list[j])
            }
        }
        return list
    }
}

class DiscardableDeck<Card> {
    var fresh = [Card]()
    var discarded = [Card]()
    
    func popLast() -> Card? {
        guard let card = fresh.popLast() else {
            fresh = discarded.shuffled()
            discarded = []
            return fresh.popLast()
        }
        return card
    }
    
    func popLast(n: Int) -> [Card] {
        return (1...n).flatMap { _ in popLast() }
    }
    
    func discard(card: Card) {
        discarded.append(card)
    }
    
    func discard(cards: [Card]) {
        discarded.appendContentsOf(cards)
    }
}