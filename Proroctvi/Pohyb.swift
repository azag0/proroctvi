enum Pohyb: CustomStringConvertible {
    enum Směr: String { case Vlevo, Vpravo }
    
    case ZůsťanNaMístě
    case JdiPěšky(Směr)
    case JeďNaKoni
    case PlujNaLodi
    case PoužijBránu
    case PoužijSchopnost
    case PoužijPředmět
    case MístoPohybuPole
    case MístoPohybuPředmět
    case JdiDoSféry
    
    var description: String {
        switch self {
        case .ZůsťanNaMístě: return "Stůj"
        case .JdiPěšky(let směr): return "Jdi \(směr)"
        default: return "Neznámý tah"
        }
    }
    
    func táhni(inout postava: Postava, inout umístění: [Postava: Int]) {
        print("Provádím tah: \(self)")
        switch self {
        case .ZůsťanNaMístě: break
        case .JdiPěšky(let směr):
            switch směr {
            case .Vlevo: umístění[postava]! -= 1
            case .Vpravo: umístění[postava]! += 1
            }
        default: break
        }
    }
}
