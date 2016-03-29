class Pole {
    let název: String
    let sféra: Sféra?
    let brána: MagickáBrána?
    var přístav: Přístav?
    
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
        case Les = "Les"
        case Pláně = "Pláně"
        case Hory = "Hory"
    }
    
    let druh: Druh
    var dobrodružství = [(karta: Dobrodružství, odkrytá: Bool)]()
    
    init(druh: Druh,
         sféra: Sféra? = nil,
         brána: MagickáBrána? = nil,
         přístav: Přístav? = nil) {
        self.druh = druh
        super.init(název: druh.rawValue, sféra: sféra, brána: brána, přístav: přístav)
    }
}

protocol Civilizace {}

class Osídlení: Pole, Civilizace {
    enum Druh: String {
        case Město = "Město"
        case Vesnice = "Vesnice"
    }
    
    var předměty = [Předmět]()
    let druh: Druh
    
    init(druh: Druh,
         sféra: Sféra? = nil,
         brána: MagickáBrána? = nil,
         přístav: Přístav? = nil) {
        self.druh = druh
        super.init(název: druh.rawValue, sféra: sféra, brána: brána, přístav: přístav)
    }
}

class PoleCechu: Pole, Civilizace {
    let cech: Cech
    var schopnosti = [Schopnost]()
    
    init(cech: Cech,
         sféra: Sféra? = nil,
         brána: MagickáBrána? = nil,
         přístav: Přístav? = nil) {
        self.cech = cech
        super.init(název: cech.rawValue, sféra: sféra, brána: brána, přístav: přístav)
    }
}

class MagickáBrána {}

typealias Přístav = [Pole]