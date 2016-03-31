class Pole: CustomStringConvertible {
    let název: String
    let sféra: Sféra?
    let brána: MagickáBrána?
    var přístav: Přístav?
    let možnosti: [Možnost] = []
    
    var description: String { return název }
    
    init(název: String,
         sféra: Sféra? = nil,
         brána: MagickáBrána? = nil,
         přístav: Přístav? = nil) {
        self.název = název
        self.sféra = sféra
        self.brána = brána
        self.přístav = přístav
    }
}

class Divočina: Pole {
    enum Druh: String {
        case Les
        case Pláně
        case Hory
    }
    
    let druh: Druh
    var dobrodružství: [(karta: Dobrodružství, odkrytá: Bool)]
    
    init(druh: Druh,
         sféra: Sféra? = nil,
         brána: MagickáBrána? = nil,
         přístav: Přístav? = nil) {
        self.druh = druh
        dobrodružství = []
        super.init(název: druh.rawValue, sféra: sféra, brána: brána, přístav: přístav)
    }
}

protocol Civilizace {}

class Osídlení: Pole, Civilizace {
    enum Druh: String {
        case Město
        case Vesnice
    }
    
    var předměty: [Předmět]
    let druh: Druh
    
    init(druh: Druh,
         sféra: Sféra? = nil,
         brána: MagickáBrána? = nil,
         přístav: Přístav? = nil) {
        self.druh = druh
        předměty = []
        super.init(název: druh.rawValue, sféra: sféra, brána: brána, přístav: přístav)
    }
}

class PoleCechu: Pole, Civilizace {
    let cech: Cech
    var schopnosti: [Schopnost]
    
    init(cech: Cech,
         sféra: Sféra? = nil,
         brána: MagickáBrána? = nil,
         přístav: Přístav? = nil) {
        self.cech = cech
        schopnosti = []
        super.init(název: cech.rawValue, sféra: sféra, brána: brána, přístav: přístav)
    }
}

class MagickáBrána {}

typealias Přístav = [Pole]