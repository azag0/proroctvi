class HerníPlán {
    let pole: [Pole]
    let běžnéPředměty: OdkládacíBalíček<BěžnýPředmět>
    let vzácnéPředměty: OdkládacíBalíček<VzácnýPředmět>
    let kartyNáhody: OdkládacíBalíček<KartaNáhody>
    let dobrodružství: OdkládacíBalíček<Dobrodružství>
    let schopnosti: [Cech: RotujícíBalíček<Schopnost>]
    let sféry: [Sféra]
    let kostky = [Kostka(), Kostka()]
    var umístěníPostav: [Postava: Pole]
    var postavy: [Postava]
    var hra: Hra? = nil
    
    init(postavy: [Postava] = []) {
        kartyNáhody = OdkládacíBalíček(karty: [
            .Charita, .DobréČasy, .Gilda, .Hokynář, .Hory, .JasnozřivýSen,
            .Klášter, .KlidnéČasy, .Krize, .Les, .Les, .LesníTábor, .MagickáVěž,
            .MagickýVítr, .MěstskýKupec, .Pevnost, .Pláně, .Pláně, .SvěžíVítr]
            .map(KartaNáhody.init))
        if postavy.count > 3 {
            kartyNáhody.karty.appendContentsOf([
                .Hory, .KlidnéČasy, .NabídkaVýcviku, .Pláně, .VolnýVýcvik,
                .ZajímavéČasy]
                .map(KartaNáhody.init))
        }
        běžnéPředměty = OdkládacíBalíček(karty: [])
        vzácnéPředměty = OdkládacíBalíček(karty: [])
        dobrodružství = OdkládacíBalíček(karty: [])
        schopnosti = [
            .Klášter: RotujícíBalíček(karty: []),
            .Gilda: RotujícíBalíček(karty: []),
            .MagickáVěž: RotujícíBalíček(karty: []),
            .Pevnost: RotujícíBalíček(karty: []),
            .LesníTábor: RotujícíBalíček(karty: [])
        ]
        sféry = (1...5).map { _ in
            Sféra(nižší: NižšíStrážce(), vyšší: VyššíStrážce(), artefakt: Artefakt())
        }
        pole = [
            Pole(název: "Magická pustina", brána: MagickáBrána()),
            Divočina(druh: .Les, sféra: sféry[0]),
            PoleCechu(cech: .LesníTábor),
            Divočina(druh: .Hory, přístav: Přístav(), sféra: sféry[0]),
            Divočina(druh: .Pláně),
            Divočina(druh: .Les, brána: MagickáBrána(), sféra: sféry[1]),
            PoleCechu(cech: .Gilda),
            Divočina(druh: .Pláně, sféra: sféry[1]),
            Osídlení(druh: .Vesnice, přístav: Přístav()),
            Divočina(druh: .Hory, brána: MagickáBrána(), sféra: sféry[2]),
            PoleCechu(cech: .MagickáVěž),
            Divočina(druh: .Les, sféra: sféry[2]),
            Divočina(druh: .Pláně, přístav: Přístav()),
            Divočina(druh: .Les, sféra: sféry[3]),
            PoleCechu(cech: .Klášter),
            Osídlení(druh: .Město, brána: MagickáBrána(), přístav: Přístav(), sféra: sféry[3]),
            Divočina(druh: .Pláně),
            Divočina(druh: .Hory, sféra: sféry[4]),
            PoleCechu(cech: .Pevnost),
            Divočina(druh: .Pláně, přístav: Přístav(), sféra: sféry[5])
        ]
        umístěníPostav = [:]
        for postava in postavy {
            umístěníPostav[postava] = PoleCechu(cech: postava.cechy.0)
        }
        self.postavy = postavy
        propojPřístavy()
    }
    
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
    
    func poleCechu(cech: Cech) -> Pole {
        return pole.flatMap { $0 as? PoleCechu } .filter { $0.cech == cech } .first!
    }
    
    var hráčNaTahu: Hráč? {
        return hra?.hráči
            .filter { $0.postava === naTahu }
            .first
    }
    
    func nováSchopnost(cech: Cech) {
        pole.flatMap { $0 as? PoleCechu }
            .filter { $0.cech == cech }
            .forEach { pole in
                guard let nováSchopnost = schopnosti[cech]!.táhni() else { return }
                pole.schopnosti.append(nováSchopnost)
                if pole.schopnosti.count > 2 {
                    schopnosti[cech]!.odlož(pole.schopnosti.popLast()!)
                }
        }
    }
    
    func propojPřístavy() {
        let přístavy = pole.filter { $0.přístav != nil }
        for (i, přístavníPole) in přístavy.enumerate() {
            přístavníPole.přístav!.append(přístavy[i > 0 ? i-1 : přístavy.count-1])
            přístavníPole.přístav!.append(přístavy[i < přístavy.count-1 ? i+1 : 0])
        }
    }
}
