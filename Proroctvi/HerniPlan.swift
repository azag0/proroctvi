/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

class HerníPlán: CustomStringConvertible {
    let pole: [Pole]
    let běžnéPředměty: OdkládacíBalíček<BěžnýPředmět>
    let vzácnéPředměty: OdkládacíBalíček<VzácnýPředmět>
    let kartyNáhody: OdkládacíBalíček<KartaNáhody>
    let dobrodružství: OdkládacíBalíček<Dobrodružství>
    let schopnosti: [Cech: RotujícíBalíček<Schopnost>]
    let sféry: [Sféra]
    let kostky = [Kostka(), Kostka()]
    var umístěníPostav: [Postava: Int] = [:]
    var postavy: [Postava]
    
    var description: String {
        var desc = "Herní Plán:\n"
        desc += "* postavy: \([Postava: Pole](umístěníPostav.map { ($0, self[$1]) }))"
        return desc
    }
    
    func polePostavy(postava: Postava) -> Pole {
        return pole[circ: umístěníPostav[postava]!]
    }
    
    subscript(idx: Int) -> Pole { return self.pole[circ: idx] }
    subscript(pole: Pole) -> Int { return self.pole.indexOf { $0 === pole }! }
    subscript(cech: Cech) -> Int { return self.pole.indexOf { ($0 as? PoleCechu)?.cech == cech }! }
    subscript(cech: Cech) -> Pole { return self[self.pole.indexOf { ($0 as? PoleCechu)?.cech == cech }!] }
    
    init(postavy: [Postava] = []) {
        var náhody: [ZákladníKartaNáhody] = [
            .Charita, .DobréČasy, .Gilda, .Hokynář, .Hory, .JasnozřivýSen,
            .Klášter, .KlidnéČasy, .Krize, .Les, .Les, .LesníTábor, .MagickáVěž,
            .MagickýVítr, .MěstskýKupec, .Pevnost, .Pláně, .Pláně, .SvěžíVítr]
        if postavy.count > 3 {
            náhody.appendContentsOf([
                .Hory, .KlidnéČasy, .NabídkaVýcviku, .Pláně, .VolnýVýcvik,
                .ZajímavéČasy])
        }
        kartyNáhody = OdkládacíBalíček(karty: náhody.map { $0 as KartaNáhody })
        kartyNáhody.zamíchej()
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
            Divočina(druh: .Pláně, přístav: Přístav(), sféra: sféry[4])
        ]
        self.postavy = postavy
        umístěníPostav = postavy.map { ($0, self[$0.cechy.first!]) }
        propojPřístavy()
    }
    
    var naTahu: Postava {
        get { return postavy.first! }
        set { postavy[0] = newValue }
    }
    var neníNaTahu: [Postava] { return postavy.filter { $0 !== naTahu } }
    
    var vesnice: Osídlení {
        return pole.flatMap { $0 as? Osídlení } .filter { $0.druh == .Vesnice } .first!
    }
    
    var město: Osídlení {
        return pole.flatMap { $0 as? Osídlení } .filter { $0.druh == .Město } .first!
    }
    
    func poleCechu(cech: Cech) -> Pole {
        return pole.flatMap { $0 as? PoleCechu } .filter { $0.cech == cech } .first!
    }
    
    func nováSchopnost(cech: Cech) {
        pole.flatMap { $0 as? PoleCechu }
            .filter { $0.cech == cech }
            .forEach { pole in
                guard let nováSchopnost = schopnosti[cech]!.táhni() else { return }
                pole.schopnosti.append(nováSchopnost)
                if pole.schopnosti.count > 2 {
                    schopnosti[cech]!.odhoď(pole.schopnosti.popLast()!)
                }
        }
    }
    
    func propojPřístavy() {
        let přístavy = pole.filter { $0.přístav != nil }
        for (i, přístavníPole) in přístavy.enumerate() {
            přístavníPole.přístav!.append(přístavy[circ: i])
            přístavníPole.přístav!.append(přístavy[circ: i])
        }
    }
    
    func odhoďPředměty(předměty: [Předmět]) {
        běžnéPředměty.odhoď(předměty.flatMap { $0 as? BěžnýPředmět })
        vzácnéPředměty.odhoď(předměty.flatMap { $0 as? VzácnýPředmět })
    }
    
    func odhoďSchopnosti(schopnosti: [Schopnost]) {
        schopnosti.forEach { self.schopnosti[$0.cech]!.odhoď($0) }
    }
}
