import Foundation

func random(maximum: Int) -> Int {
    return numericCast(arc4random_uniform(numericCast(maximum)))
}

class Kostka {
    func hoď() -> Int {
        return random(6)+1
    }
}