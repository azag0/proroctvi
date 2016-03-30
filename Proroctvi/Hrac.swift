protocol Hráč {
    var postava: Postava? { get set }
    func volnýVýcvikKterýCech(plán: HerníPlán) -> Cech
    func jasnozřivýSenKteráSféra(plán: HerníPlán) -> Sféra
    func odhoďKteréPředměty(předměty: [Předmět], odhoďKolik: Int) -> [Předmět]
    func odhoďKteréSchopnosti(schopnosti: [Schopnost], odhoďKolik: Int) -> [Schopnost]
}