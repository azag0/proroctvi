class Hráč {
    var postava: Postava? = nil
    
    func volnýVýcvikKterýCech(plán: HerníPlán) -> Cech {
        return .Gilda
    }
    
    func jasnozřivýSenKteráSféra(plán: HerníPlán) -> Sféra {
        return plán.sféry.first!
    }
}