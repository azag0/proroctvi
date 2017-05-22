/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

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

protocol Odhoditelný {
    associatedtype Karta
    func odhoď(karta: Karta)
    func odhoď(karty: [Karta])
}

class RotujícíBalíček<Karta>: Balíček<Karta>, Odhoditelný {
    override init(karty: [Karta]) { super.init(karty: karty) }
    
    func odhoď(karta: Karta) {
        karty.append(karta)
    }
    
    func odhoď(karty: [Karta]) {
        self.karty.appendContentsOf(karty)
    }

}

class OdkládacíBalíček<Karta>: Balíček<Karta>, Odhoditelný {
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
    
    func odhoď(karta: Karta) {
        odkládacíHromádka.append(karta)
    }
    
    func odhoď(karty: [Karta]) {
        odkládacíHromádka.appendContentsOf(karty)
    }
}