class KartaNáhody {
    let název: String
    let použij: HerníPlán -> Upravovač?
    
    init(název: String, použij: HerníPlán -> Upravovač?) {
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
        var použij: HerníPlán -> Upravovač?
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
                return nil
            }
        case .Hokynář:
            použij = { plán in
                plán.odhoďPředměty(plán.vesnice.předměty)
                plán.vesnice.předměty = plán.běžnéPředměty.táhni(2)
                return nil
            }
        case .MěstskýKupec:
            použij = { plán in
                plán.odhoďPředměty(plán.město.předměty)
                plán.město.předměty = plán.běžnéPředměty.táhni(1) as [Předmět] +
                    plán.vzácnéPředměty.táhni(1) as [Předmět]
                return nil
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
                return nil
            }
        case .LesníTábor, .Gilda, .MagickáVěž, .Pevnost, .Klášter:
            použij = { plán in
                plán.nováSchopnost(Cech(rawValue: druh.rawValue)!)
                return nil
            }
        case .Krize:
            použij = { plán in
                if plán.kostky.first!.hoď() != 6 {
                    plán.postavy.forEach { postava in
                        postava.zlato -= postava.zlato/2
                    }
                }
                return nil
            }
        case .SvěžíVítr:
            použij = { plán in
                plán.naTahu.síla += 2
                plán.neníNaTahu.forEach { $0.síla += 1 }
                return nil
            }
        case .DobréČasy:
            použij = { plán in
                plán.naTahu.zlato += 4
                plán.neníNaTahu.forEach { $0.zlato += 2 }
                return nil
            }
        case .MagickýVítr:
            použij = { plán in
                plán.naTahu.vůle += 4
                plán.neníNaTahu.forEach { $0.vůle += 2 }
                return nil
            }
        case .ZajímavéČasy:
            použij = { plán in
                plán.naTahu.zkušenosti += 2
                plán.neníNaTahu.forEach { $0.zkušenosti += 1 }
                return nil
            }
        case .VolnýVýcvik:
            použij = { plán in
                return .Dotaz({ hráč in
                    plán.nováSchopnost(hráč.volnýVýcvikKterýCech(plán))
                })
            }
        case .NabídkaVýcviku:
            použij = { plán in
                plán.naTahu.cechyZadarmo.forEach { plán.nováSchopnost($0) }
                return nil
            }
        case .KlidnéČasy:
            použij = { plán in
                return .UpravKolo({ kolo in kolo.početTahů += 1 })
            }
        case .JasnozřivýSen:
            použij = { plán in
                return .Dotaz({ hráč in
                    var sféra = hráč.jasnozřivýSenKteráSféra(plán)
                    sféra.odkryj()
                })
            }
        }
        self.init(název: název, použij: použij)
    }
}