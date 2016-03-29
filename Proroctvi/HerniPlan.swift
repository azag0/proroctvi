class HerníPlán {
    var postavy = [Postava]()
    let pole = [Pole]()
    let běžnéPředměty = DiscardableDeck<BěžnýPředmět>()
    let vzácnéPředměty = DiscardableDeck<VzácnýPředmět>()
    let kartyNáhody = DiscardableDeck<KartaNáhody>()
    let dobrodružství = DiscardableDeck<Dobrodružství>()
    var schopnosti = [Cech: [Schopnost]]()
    let kostky = [Kostka(), Kostka()]
    let sféry = [Sféra]()
    var hra: Hra? = nil
    var kolo = Kolo()
    
    var vesnice: Osídlení {
        get {
            return pole.flatMap { $0 as? Osídlení }
                .filter { $0.druh == .Vesnice }
                .first!
        }
    }
    
    var město: Osídlení {
        get {
            return pole.flatMap { $0 as? Osídlení }
                .filter { $0.druh == .Město }
                .first!
        }
    }
    
    var naTahu: Postava {
        get { return postavy.first! }
    }
    
    var neníNaTahu: [Postava] {
        get { return postavy.filter { $0 !== naTahu } }
    }
    
    var hráčNaTahu: Hráč? {
        return hra!.hráči
            .filter { $0.postava === naTahu }
            .first!
    }
    
    func nováSchopnost(cech: Cech) {
        pole.flatMap { $0 as? PoleCechu }
            .filter { $0.cech == cech }
            .forEach { pole in
                guard let nováSchopnost = schopnosti[cech]!.popLast() else { return }
                pole.schopnosti.append(nováSchopnost)
                if pole.schopnosti.count > 2 {
                    schopnosti[cech]!.insert(pole.schopnosti.popLast()!, atIndex: 0)
                }
        }
    }
}