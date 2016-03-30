func == (vlevo: Postava, vpravo: Postava) -> Bool {
    return vlevo.povolání == vpravo.povolání
}

class Postava: Hashable, Bojující {
    enum Povolání: String {
        case Mystik
        case Vědma
        case Iluzionistka
        case Žoldák
        case PotulnýMnich = "Potulný mnich"
        case Zvěd
        case Paladin
        case Hraničářka
        case Zaklínačka
        case Druid
    }
    
    let povolání: Povolání
    let cechy: [Cech]
    var plnáVůle: Int
    var plnáSíla: Int
    var magy: Int
    var životy: Int
    var zlato = 5
    var zkušenosti = 5
    var předměty: [Předmět] = []
    var schopnosti: [Schopnost] = []
    
    var hashValue: Int { return povolání.hashValue }
    var cechyZadarmo: [Cech] { return cechy }
    
    var síla: Int {
        get { return životy }
        set { životy = max(plnáSíla, newValue) }
    }
    
    var vůle: Int {
        get { return magy }
        set { magy = max(plnáVůle, newValue) }
    }
    
    init(_ povolání: Povolání, cechy: [Cech], síla: Int, vůle: Int) {
        self.povolání = povolání
        self.cechy = cechy
        self.plnáVůle = vůle
        self.magy = vůle
        self.plnáSíla = síla
        self.životy = síla
    }
    
    convenience init(povolání: Povolání) {
        switch povolání {
        case .Mystik: self.init(povolání, cechy: [.Klášter, .MagickáVěž], síla: 3, vůle: 6)
        case .Vědma: self.init(povolání, cechy: [.MagickáVěž, .LesníTábor], síla: 3, vůle: 6)
        case .Iluzionistka: self.init(povolání, cechy: [.MagickáVěž, .Gilda], síla: 4, vůle: 4)
        case .Žoldák: self.init(povolání, cechy: [.Gilda, .Pevnost], síla: 5, vůle: 2)
        case .PotulnýMnich: self.init(povolání, cechy: [.Klášter, .Gilda], síla: 4, vůle: 4)
        case .Zvěd: self.init(povolání, cechy: [.Gilda, .LesníTábor], síla: 5, vůle: 2)
        case .Paladin: self.init(povolání, cechy: [.Pevnost, .Klášter], síla: 4, vůle: 4)
        case .Hraničářka: self.init(povolání, cechy: [.LesníTábor, .Pevnost], síla: 5, vůle: 2)
        case .Zaklínačka: self.init(povolání, cechy: [.Pevnost, .MagickáVěž], síla: 4, vůle: 4)
        case .Druid: self.init(povolání, cechy: [.LesníTábor, .Klášter], síla: 3, vůle: 6)
        }
    }

    func upravMaxima() -> ((Hráč, HerníPlán) -> Void)? {
        zkušenosti = min(zkušenosti, 15)
        zlato = min(zlato, 15)
        if předměty.count > 7 || schopnosti.count > 7 {
            return { hráč, plán in
                if self.předměty.count > 7 {
                    let odhozené = hráč.odhoďKteréPředměty(self.předměty, odhoďKolik: self.předměty.count-7)
                    self.předměty = self.předměty.filter { předmět in odhozené.contains { $0 !== předmět } }
                    plán.odhoďPředměty(odhozené)
                }
                if self.schopnosti.count > 7 {
                    let odhozené = hráč.odhoďKteréSchopnosti(self.schopnosti, odhoďKolik: self.schopnosti.count-7)
                    self.schopnosti = self.schopnosti.filter { schopnost in odhozené.contains { $0 !== schopnost } }
                    plán.odhoďSchopnosti(odhozené)
                }
            }
        } else {
            return nil
        }
    }
}