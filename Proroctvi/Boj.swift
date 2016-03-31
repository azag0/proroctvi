protocol Bojující {}

class Boj {
    var útočník: Bojující
    var obránce: Bojující
    
    init(útočník: Bojující, obránce: Bojující) {
        self.útočník = útočník
        self.obránce = obránce
    }
    
    func bojujte() -> Výsledek {
        return .Remíza
    }
}

enum Výsledek {
    case Prohra
    case Remíza
    case Vítězství
}