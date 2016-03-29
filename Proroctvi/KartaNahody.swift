class KartaNáhody {
    let název: String
    let použij: HerníPlán -> Void
    
    init(název: String, použij: HerníPlán -> Void) {
        self.název = název
        self.použij = použij
    }
    
    enum Druh: String {
        case Charita = "Charita"
        case DobréČasy = "Dobré časy"
        case Gilda = "Gilda"
        case Hokynář = "Hokynář"
        case Hory = "Hory"
        case JasnozřivýSen = "Jasnozřivý sen"
        case KlidnéČasy = "Klidné časy"
        case Klášter = "Klášter"
        case Krize = "Krize"
        case Les = "Les"
        case LesníTábor = "Lesní tábor"
        case MagickáVěž = "Magická věž"
        case MagickýVítr = "Magický vítr"
        case MěstskýKupec = "Městský kupec"
        case Pevnost = "Pevnost"
        case Pláně = "Pláně"
        case SvěžíVítr = "Svěží vítr"
        case NabídkaVýcviku = "Nabídka výcviku"
        case VolnýVýcvik = "Volný výcvik"
        case ZajímavéČasy = "Zajímavé časy"
    }
    
    convenience init(druh: Druh) {
        let název = druh.rawValue
        var použij: HerníPlán -> Void
        switch druh {
        case .Charita:
            použij = { plán in
                let minZlato = plán.postavy.map({ $0.zlato }).minElement()
                let minSíla = plán.postavy.map({ $0.síla }).minElement()
                let minVůle = plán.postavy.map({ $0.vůle }).minElement()
                plán.postavy.forEach { postava in
                    if postava.zlato == minZlato { postava.zlato += 3 }
                    if postava.síla == minSíla { postava.síla += 1 }
                    if postava.vůle == minVůle { postava.vůle += 2 }
                }
            }
        case .Hokynář:
            použij = { plán in
                plán.běžnéPředměty.odlož(plán.vesnice.předměty as! [BěžnýPředmět])
                plán.vesnice.předměty = plán.běžnéPředměty.táhni(2)
            }
        case .MěstskýKupec:
            použij = { plán in
                plán.běžnéPředměty.odlož(plán.město.předměty.flatMap { $0 as? BěžnýPředmět })
                plán.vzácnéPředměty.odlož(plán.město.předměty.flatMap { $0 as? VzácnýPředmět })
                plán.město.předměty = plán.běžnéPředměty.táhni(1) as [Předmět] +
                    plán.vzácnéPředměty.táhni(1) as [Předmět]
            }
        case .Les, .Hory, .Pláně:
            použij = { plán in
                plán.pole.flatMap { $0 as? Divočina }
                    .filter { $0.druh.rawValue == druh.rawValue }
                    .forEach { pole in
                        if pole.dobrodružství.count < 2 {
                            pole.dobrodružství.insert((plán.dobrodružství.táhni()!, false), atIndex: 0)
                        }
                }
            }
        case .LesníTábor, .Gilda, .MagickáVěž, .Pevnost, .Klášter:
            použij = { plán in plán.nováSchopnost(Cech(rawValue: druh.rawValue)!) }
        case .Krize:
            použij = { plán in
                if plán.kostky.first!.hoď() != 6 {
                    plán.postavy.forEach { postava in
                        postava.zlato -= postava.zlato/2
                    }
                }
            }
        case .SvěžíVítr:
            použij = { plán in
                plán.naTahu.síla += 2
                plán.neníNaTahu.forEach { $0.síla += 1 }
            }
        case .DobréČasy:
            použij = { plán in
                plán.naTahu.zlato += 4
                plán.neníNaTahu.forEach { $0.zlato += 2 }
            }
        case .MagickýVítr:
            použij = { plán in
                plán.naTahu.vůle += 4
                plán.neníNaTahu.forEach { $0.vůle += 2 }
            }
        case .ZajímavéČasy:
            použij = { plán in
                plán.naTahu.zkušenosti += 2
                plán.neníNaTahu.forEach { $0.zkušenosti += 1 }
            }
        case .VolnýVýcvik:
            použij = { plán in
                plán.nováSchopnost(plán.hráčNaTahu!.volnýVýcvikKterýCech(plán))
            }
        case .NabídkaVýcviku:
            použij = { plán in
                plán.naTahu.cechyZadarmo.forEach { plán.nováSchopnost($0) }
            }
        case .KlidnéČasy:
            použij = { plán in
                plán.kolo.početTahů += 1
            }
        case .JasnozřivýSen:
            použij = { plán in
                var sféra = plán.hráčNaTahu!.jasnozřivýSenKteráSféra(plán)
                sféra.odkryj()
            }
        }
        self.init(název: název, použij: použij)
    }
}