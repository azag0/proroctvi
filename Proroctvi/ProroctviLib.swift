class Kostka {
    func hoď() -> Int {
        return random(6)+1
    }
}

class Předmět {
}

class BěžnýPředmět: Předmět {
}

class VzácnýPředmět: Předmět {
}

protocol Dobrodružství {
}

class Stvůra {
}

class Nestvůra: Stvůra, Dobrodružství {
}

class Příležitost: Dobrodružství {
}

class NižšíStrážce: Stvůra {
}

class VyššíStrážce: Stvůra {
}

class Artefakt: Předmět {
}

struct Sféra {
    let nižšíStrážce: NižšíStrážce
    let vyššíStrážce: VyššíStrážce
    let artefakt: Artefakt
    var odkryto = 0
    
    mutating func odkryj() {
        if odkryto < 3 { odkryto += 1 }
    }
}

class Schopnost {
    let cech: Cech
    
    init(cech: Cech) {
        self.cech = cech
    }
}

class Pole {
}

class Divočina: Pole {
    enum Druh: String {
        case Les = "Les"
        case Pláně = "Pláně"
        case Hory = "Hory"
    }
    
    let druh: Druh
    var dobrodružství = [(Dobrodružství, Bool)]()
    
    init(druh: Druh) {
        self.druh = druh
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
    
    init(druh: Druh) {
        self.druh = druh
    }
}

class PoleCechu: Pole, Civilizace {
    let cech: Cech
    var schopnosti = [Schopnost]()
    
    init(cech: Cech) {
        self.cech = cech
    }
}

class Kolo {
    var početTahů = 1
}

class Pravidla {
}

class Hráč {
    var postava: Postava? = nil
    
    func volnýVýcvikKterýCech(plán: HerníPlán) -> Cech {
        return .Gilda
    }
    
    func jasnozřivýSenKteráSféra(plán: HerníPlán) -> Sféra {
        return plán.sféry.first!
    }
}

class Hra {
    let herníPlán = HerníPlán()
    let pravidla = Pravidla()
    let hráči = [Hráč]()
    
    func tah() {
    }
}
