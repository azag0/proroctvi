class Kolo {
    var početTahů: Int = 1
    
    func proveďTahy(hra: Hra) {
        while početTahů > 0 {
            let tah = Tah()
            tah.proveď(hra)
            početTahů -= 1
        }
    }
}
