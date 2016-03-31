protocol KartaNáhody {
    var název: String { get }
    func použij(plán: HerníPlán) -> Upravovač?
}

enum ZákladníKartaNáhody: String, KartaNáhody {
    case Charita
    case DobréČasy = "Dobré časy"
    case Gilda
    case Hokynář
    case Hory
    case JasnozřivýSen = "Jasnozřivý sen"
    case KlidnéČasy = "Klidné časy"
    case Klášter
    case Krize
    case Les
    case LesníTábor = "Lesní tábor"
    case MagickáVěž = "Magická věž"
    case MagickýVítr = "Magický vítr"
    case MěstskýKupec = "Městský kupec"
    case Pevnost
    case Pláně
    case SvěžíVítr = "Svěží vítr"
    case NabídkaVýcviku = "Nabídka výcviku"
    case VolnýVýcvik = "Volný výcvik"
    case ZajímavéČasy = "Zajímavé časy"
    
    var název: String { return self.rawValue }
    
    func použij(plán: HerníPlán) -> Upravovač? {
        switch self {
        case .Charita:
            let minZlato = plán.postavy.map { $0.zlato } .minElement()
            let minSíla = plán.postavy.map { $0.síla } .minElement()
            let minVůle = plán.postavy.map { $0.vůle } .minElement()
            plán.postavy.forEach { postava in
                if postava.zlato == minZlato { postava.zlato += 3 }
                if postava.síla == minSíla { postava.síla += 1 }
                if postava.vůle == minVůle { postava.vůle += 2 }
            }
        case .Hokynář:
            plán.odhoďPředměty(plán.vesnice.předměty)
            plán.vesnice.předměty = plán.běžnéPředměty.táhni(2)
        case .MěstskýKupec:
            plán.odhoďPředměty(plán.město.předměty)
            plán.město.předměty = plán.běžnéPředměty.táhni(1) as [Předmět] +
                plán.vzácnéPředměty.táhni(1) as [Předmět]
        case .Les, .Hory, .Pláně:
            plán.pole.flatMap { $0 as? Divočina }
                .filter { $0.druh.rawValue == rawValue }
                .forEach { pole in
                    pole.dobrodružství.insertContentsOf(
                        plán.dobrodružství.táhni(2-pole.dobrodružství.count).map { ($0, false) },
                        at: 0
                    )
            }
        case .LesníTábor, .Gilda, .MagickáVěž, .Pevnost, .Klášter:
            plán.nováSchopnost(Cech(rawValue: rawValue)!)
        case .Krize:
            if plán.kostky.first!.hoď() != 6 {
                plán.postavy.forEach { postava in
                    postava.zlato -= postava.zlato/2
                }
            }
        case .SvěžíVítr:
            plán.naTahu.síla += 2
            plán.neníNaTahu.forEach { $0.síla += 1 }
        case .DobréČasy:
            plán.naTahu.zlato += 4
            plán.neníNaTahu.forEach { $0.zlato += 2 }
        case .MagickýVítr:
            plán.naTahu.vůle += 4
            plán.neníNaTahu.forEach { $0.vůle += 2 }
        case .ZajímavéČasy:
            plán.naTahu.zkušenosti += 2
            plán.neníNaTahu.forEach { $0.zkušenosti += 1 }
        case .VolnýVýcvik:
            return .Dotaz({ hráč in
                plán.nováSchopnost(hráč.volnýVýcvikKterýCech(plán))
            })
        case .NabídkaVýcviku:
            plán.naTahu.cechyZadarmo.forEach { plán.nováSchopnost($0) }
        case .KlidnéČasy:
            return .UpravKolo({ kolo in kolo.početTahů += 1 })
        case .JasnozřivýSen:
            return .Dotaz({ hráč in
                var sféra = hráč.jasnozřivýSenKteráSféra(plán)
                sféra.odkryj()
            })
        }
        return nil
    }
}