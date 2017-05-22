/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

class Hra {
    let plán: HerníPlán
    let hráči: [Hráč]
    
    var hráčNaTahu: Hráč { return hráči.filter { $0.postava == plán.naTahu } .first! }
    
    init(hráči: [Hráč] = []) {
        self.plán = HerníPlán(postavy: hráči.map { $0.postava! })
        self.hráči = hráči
    }
    
    func proveďKolo() {
        let kolo = Kolo()
        print("Postava na tahu: \(plán.naTahu)")
        let kartaNáhody = plán.kartyNáhody.táhni()!
        if let upravovač = kartaNáhody.použij(plán) {
            switch upravovač {
            case .Dotaz(let dotaz):
                dotaz(hráčNaTahu)
            case .UpravKolo(let uprav):
                uprav(kolo)
            }
        }
        plán.kartyNáhody.odhoď(kartaNáhody)
        kolo.proveďTahy(self)
        if let uprav = plán.naTahu.upravMaxima() { uprav(hráčNaTahu, plán) }
        plán.postavy.append(plán.postavy.removeFirst())
    }
}

enum Upravovač {
    case Dotaz(Hráč -> Void)
    case UpravKolo(Kolo -> Void)
}