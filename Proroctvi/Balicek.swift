extension Array {
    mutating func shuffle() {
        if count < 2 { return }
        for i in 0..<count-1 {
            let j = random(count-i)+i
            if i != j {
                swap(&self[i], &self[j])
            }
        }
    }
}

class Balíček<Karta> {
    var karty: [Karta]
    
    init(karty: [Karta]) {
        self.karty = karty
    }
    
    func táhni() -> Karta? {
        return karty.count > 0 ? karty.removeAtIndex(0) : nil
    }
    
    func táhni(n: Int) -> [Karta] {
        return (1...n).flatMap { _ in táhni() }
    }
    
    func zamíchej() {
        karty.shuffle()
    }
}

protocol Odkládací {
    associatedtype Karta
    func odlož(karta: Karta)
    func odlož(karty: [Karta])
}

class RotujícíBalíček<Karta>: Balíček<Karta>, Odkládací {
    override init(karty: [Karta]) { super.init(karty: karty) }
    
    func odlož(karta: Karta) {
        karty.append(karta)
    }
    
    func odlož(karty: [Karta]) {
        self.karty.appendContentsOf(karty)
    }

}

class OdkládacíBalíček<Karta>: Balíček<Karta>, Odkládací {
    var odkládacíHromádka: [Karta] = []
    
    override init(karty: [Karta]) { super.init(karty: karty) }
    
    func obnov() {
        karty = odkládacíHromádka
        odkládacíHromádka = []
        zamíchej()
    }

    override func táhni() -> Karta? {
        if karty.count == 0 { obnov() }
        return super.táhni()
    }
    
    override func táhni(n: Int) -> [Karta] {
        if karty.count == 0 { obnov() }
        return super.táhni(n)
    }
    
    func odlož(karta: Karta) {
        odkládacíHromádka.append(karta)
    }
    
    func odlož(karty: [Karta]) {
        odkládacíHromádka.appendContentsOf(karty)
    }
}