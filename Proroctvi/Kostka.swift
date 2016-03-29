import Foundation

func random(maximum: Int) -> Int {
    return Int(arc4random_uniform(UInt32(maximum)))
}

class Kostka {
    func hoď() -> Int {
        return random(6)+1
    }
}