protocol Hráč {
    var postava: Postava? { get set }
    func volnýVýcvikKterýCech(plán: HerníPlán) -> Cech
    func jasnozřivýSenKteráSféra(plán: HerníPlán) -> Sféra
    func odhoďKteréPředměty(předměty: [Předmět], odhoďKolik: Int) -> [Předmět]
    func odhoďKteréSchopnosti(schopnosti: [Schopnost], odhoďKolik: Int) -> [Schopnost]
    func kterýPohyb(pohyby: [Pohyb]) -> Pohyb
    func pořadíNestvůr(inout nestvůry: [Nestvůra])
    func bojujSKterouPostavou(postavy: [Postava]) -> Postava?
    func vyberMožnost(možnosti: [Možnost]) -> Možnost?
}

class HloupýHráč: Hráč {
    var postava: Postava?
    
    func volnýVýcvikKterýCech(plán: HerníPlán) -> Cech {
        return .Gilda
    }

    func jasnozřivýSenKteráSféra(plán: HerníPlán) -> Sféra {
        return plán.sféry.first!
    }
    
    func odhoďKteréPředměty(předměty: [Předmět], odhoďKolik: Int) -> [Předmět] {
        return Array(předměty.prefix(odhoďKolik))
    }
    
    func odhoďKteréSchopnosti(schopnosti: [Schopnost], odhoďKolik: Int) -> [Schopnost] {
        return Array(schopnosti.prefix(odhoďKolik))
    }
    
    func kterýPohyb(pohyby: [Pohyb]) -> Pohyb {
        return pohyby.first!
    }
    
    func pořadíNestvůr(inout nestvůry: [Nestvůra]) {
    }
    
    func bojujSKterouPostavou(postavy: [Postava]) -> Postava? {
        return nil
    }
    
    func vyberMožnost(možnosti: [Možnost]) -> Možnost? {
        return nil
    }
}