class Hra {
    let plán: HerníPlán
    let hráči: [Hráč]
    
    var naTahu: Hráč { return hráči.filter { $0.postava == plán.naTahu } .first! }
    
    init(hráči: [Hráč] = []) {
        self.plán = HerníPlán()
        self.hráči = hráči
    }
    
    func proveďKolo() {
        let kolo = Kolo()
        let kartaNáhody = plán.kartyNáhody.táhni()!
        if let upravovač = kartaNáhody.použij(plán) {
            switch upravovač {
            case .Dotaz(let dotaz):
                dotaz(naTahu)
            case .UpravKolo(let uprav):
                uprav(kolo)
            }
        }
        plán.kartyNáhody.odhoď(kartaNáhody)
        kolo.proveďTahy(self)
        if let uprav = plán.naTahu.upravMaxima() { uprav(naTahu, plán) }
    }
}

class Kolo {
    var početTahů: Int = 1
    
    func proveďTahy(hra: Hra) {
        while početTahů > 0 {
            let tah = Tah()
            tah.proveď(hra)
            početTahů -= 1
        }
    }
}

class Tah {
    func proveď(hra: Hra) {
        let možnéPohyby = [Pohyb]()
        let pohyb = hra.naTahu.kterýPohyb(možnéPohyby)
        switch pohyb {
        default:
            break
        }
        let pole = hra.plán.umístěníPostav[hra.plán.naTahu]!
        if let divočina = pole as? Divočina {
            var dobrodružství = divočina.dobrodružství.map { $0.karta }
            var nestvůry = dobrodružství.flatMap { $0 as? Nestvůra }
            dobrodružství = dobrodružství.flatMap { $0 as? Příležitost }
            if nestvůry.count > 1 { hra.naTahu.pořadíNestvůr(&nestvůry) }
            while nestvůry.count > 0 {
                let nestvůra = nestvůry.removeFirst()
                let výsledek = Boj(útočník: hra.plán.naTahu, obránce: nestvůra).bojujte()
                switch výsledek {
                case .Prohra, .Remíza:
                    nestvůry.insert(nestvůra, atIndex: 0)
                case .Vítězství:
                    hra.plán.dobrodružství.odhoď(nestvůra)
                }
                dobrodružství.insertContentsOf(nestvůry as [Dobrodružství], at: 0)
                divočina.dobrodružství = dobrodružství.map { ($0, true) }
                switch výsledek {
                case .Prohra, .Remíza: return
                case .Vítězství: break
                }
            }
        }
        let dalšíPostavy = hra.plán.postavy.filter { hra.plán.umístěníPostav[$0] === pole }
        if dalšíPostavy.count > 0 {
            if let protivník = hra.naTahu.bojujSKterouPostavou(dalšíPostavy) {
                Boj(útočník: hra.plán.naTahu, obránce: protivník).bojujte()
            }
        }
        while let možnost = hra.naTahu.vyberMožnost(pole.možnosti) {
            možnost.využij()
        }
    }
}

enum Výsledek {
    case Prohra
    case Remíza
    case Vítězství
}

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

enum Pohyb {
    case ZůsťanNaMístě
    case JdiPěšky
    case JeďNaKoni
    case PlujNaLodi
    case PoužijBránu
    case PoužijSchopnost
    case PoužijPředmět
    case MístoPohybuPole
    case MístoPohybuPředmět
    case JdiDoSféry
}

enum Upravovač {
    case Dotaz(Hráč -> Void)
    case UpravKolo(Kolo -> Void)
}