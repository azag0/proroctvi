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
            proveďTah(hra)
            početTahů -= 1
        }
    }
    
    func proveďTah(hra: Hra) {
        
    }
}

enum Upravovač {
    case Dotaz(Hráč -> Void)
    case UpravKolo(Kolo -> Void)
}