class Postava {
    enum Povolání: String {
        case Mystik = "Mystik"
        case Vědma = "Vědma"
        case Iluzionistka = "Iluzionistka"
        case Žoldák = "Žoldák"
        case PotulnýMnich = "Potulný mnich"
        case Zvěd = "Zvěd"
        case Paladin = "Paladin"
        case Hraničářka = "Hraničářka"
        case Zaklínačka = "Zaklínačka"
        case Druid = "Druid"
    }
    
    let povolání: Povolání
    let cechy: (Cech, Cech)
    var plnáVůle: Int
    var plnáSíla: Int
    var magy: Int
    var životy: Int
    var zlato = 5
    var zkušenosti = 5
    
    var cechyZadarmo: [Cech] {
        get { return [cechy.0, cechy.1] }
    }
    
    init(_ povolání: Povolání, cechy: (Cech, Cech), síla: Int, vůle: Int) {
        self.povolání = povolání
        self.cechy = cechy
        self.plnáVůle = vůle
        self.magy = vůle
        self.plnáSíla = síla
        self.životy = síla
    }
    
    convenience init(povolání: Povolání) {
        switch povolání {
        case .Mystik: self.init(povolání, cechy: (.Klášter, .MagickáVěž), síla: 3, vůle: 6)
        case .Vědma: self.init(povolání, cechy: (.MagickáVěž, .LesníTábor), síla: 3, vůle: 6)
        case .Iluzionistka: self.init(povolání, cechy: (.MagickáVěž, .Gilda), síla: 4, vůle: 4)
        case .Žoldák: self.init(povolání, cechy: (.Gilda, .Pevnost), síla: 5, vůle: 2)
        case .PotulnýMnich: self.init(povolání, cechy: (.Klášter, .Gilda), síla: 4, vůle: 4)
        case .Zvěd: self.init(povolání, cechy: (.Gilda, .LesníTábor), síla: 5, vůle: 2)
        case .Paladin: self.init(povolání, cechy: (.Pevnost, .Klášter), síla: 4, vůle: 4)
        case .Hraničářka: self.init(povolání, cechy: (.LesníTábor, .Pevnost), síla: 5, vůle: 2)
        case .Zaklínačka: self.init(povolání, cechy: (.Pevnost, .MagickáVěž), síla: 4, vůle: 4)
        case .Druid: self.init(povolání, cechy: (.LesníTábor, .Klášter), síla: 3, vůle: 6)
        }
    }
    
    var síla: Int {
        get { return životy }
        set { životy = max(plnáSíla, newValue) }
    }
    
    var vůle: Int {
        get { return magy }
        set { magy = max(plnáVůle, newValue) }
    }
}