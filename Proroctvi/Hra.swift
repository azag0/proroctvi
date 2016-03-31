class Hra {
    let plán: HerníPlán
    let hráči: [Hráč]
    
    var hráčNaTahu: Hráč { return hráči.filter { $0.postava == plán.naTahu } .first! }
    
    init(hráči: [Hráč] = []) {
        self.plán = HerníPlán(postavy: hráči.map { $0.postava! })
        self.hráči = hráči
    }
    
    func proveďKolo() {
        let kolo = Kolo()
        print("Postava na tahu: \(plán.naTahu)")
        let kartaNáhody = plán.kartyNáhody.táhni()!
        if let upravovač = kartaNáhody.použij(plán) {
            switch upravovač {
            case .Dotaz(let dotaz):
                dotaz(hráčNaTahu)
            case .UpravKolo(let uprav):
                uprav(kolo)
            }
        }
        plán.kartyNáhody.odhoď(kartaNáhody)
        kolo.proveďTahy(self)
        if let uprav = plán.naTahu.upravMaxima() { uprav(hráčNaTahu, plán) }
        plán.postavy.append(plán.postavy.removeFirst())
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
        let možnéPohyby: [Pohyb] = [.JdiPěšky(.Vlevo)]
        hra.hráčNaTahu.kterýPohyb(možnéPohyby).táhni(&hra.plán.naTahu, umístění: &hra.plán.umístěníPostav)
        let pole = hra.plán.polePostavy(hra.plán.naTahu)
        if let divočina = pole as? Divočina {
            divočina.dobrodružství = divočina.dobrodružství.map { karta, _ in (karta, true) }
            var nestvůry = divočina.dobrodružství.flatMap { $0.karta as? Nestvůra }
            if nestvůry.count > 1 { hra.hráčNaTahu.pořadíNestvůr(&nestvůry) }
            while nestvůry.count > 0 {
                let nestvůra = nestvůry.removeFirst()
                let výsledek = Boj(útočník: hra.plán.naTahu, obránce: nestvůra).bojujte()
                switch výsledek {
                case .Prohra, .Remíza:
                    return
                case .Vítězství:
                    divočina.dobrodružství.removeAtIndex(
                        divočina.dobrodružství.indexOf { $0.karta as? Nestvůra === nestvůra }!
                    )
                    hra.plán.dobrodružství.odhoď(nestvůra)
                }
            }
        }
        let dalšíPostavy = hra.plán.postavy.filter { hra.plán.umístěníPostav[$0] == hra.plán[pole] }
        if dalšíPostavy.count > 0 {
            if let protivník = hra.hráčNaTahu.bojujSKterouPostavou(dalšíPostavy) {
                Boj(útočník: hra.plán.naTahu, obránce: protivník).bojujte()
            }
        }
        while let možnost = hra.hráčNaTahu.vyberMožnost(pole.možnosti) {
            možnost.využij()
        }
    }
}

enum Možnost {
    case KartaPříležitosti
    case Výcvik
    case Oprava
    case NákupProdej
    case Léčení
    case Magenergie
    case Nocleh
    case Artefakt
    
    func využij() {
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

enum Pohyb: CustomStringConvertible {
    enum Směr: String { case Vlevo, Vpravo }
    
    case ZůsťanNaMístě
    case JdiPěšky(Směr)
    case JeďNaKoni
    case PlujNaLodi
    case PoužijBránu
    case PoužijSchopnost
    case PoužijPředmět
    case MístoPohybuPole
    case MístoPohybuPředmět
    case JdiDoSféry
    
    var description: String {
        switch self {
        case .ZůsťanNaMístě: return "Stůj"
        case .JdiPěšky(let směr): return "Jdi \(směr)"
        default: return "Neznámý tah"
        }
    }
    
    func táhni(inout postava: Postava, inout umístění: [Postava: Int]) {
        print("Provádím tah: \(self)")
        switch self {
        case .ZůsťanNaMístě: break
        case .JdiPěšky(let směr):
            switch směr {
            case .Vlevo: umístění[postava]! -= 1
            case .Vpravo: umístění[postava]! += 1
            }
        default: break
        }
    }
}

enum Upravovač {
    case Dotaz(Hráč -> Void)
    case UpravKolo(Kolo -> Void)
}