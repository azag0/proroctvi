/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

class Tah {
    func proveď(hra: Hra) {
        let možnéPohyby: [Pohyb] = [.JdiPěšky(.Vlevo)]
        hra.hráčNaTahu.kterýPohyb(možnéPohyby).táhni(&hra.plán.naTahu, umístění: &hra.plán.umístěníPostav)
        let pole = hra.plán.polePostavy(hra.plán.naTahu)
        if let divočina = pole as? Divočina {
            divočina.dobrodružství = divočina.dobrodružství.map { karta, _ in (karta, true) }
            var nestvůry = divočina.dobrodružství.flatMap { $0.karta as? Nestvůra }
            if nestvůry.count > 1 { hra.hráčNaTahu.pořadíNestvůr(&nestvůry) }
            while nestvůry.count > 0 {
                let nestvůra = nestvůry.removeFirst()
                let výsledek = Boj(útočník: hra.plán.naTahu, obránce: nestvůra).bojujte()
                switch výsledek {
                case .Prohra, .Remíza:
                    return
                case .Vítězství:
                    divočina.dobrodružství.removeAtIndex(
                        divočina.dobrodružství.indexOf { $0.karta as? Nestvůra === nestvůra }!
                    )
                    hra.plán.dobrodružství.odhoď(nestvůra)
                }
            }
        }
        let dalšíPostavy = hra.plán.postavy.filter { hra.plán.umístěníPostav[$0] == hra.plán[pole] }
        if dalšíPostavy.count > 0 {
            if let protivník = hra.hráčNaTahu.bojujSKterouPostavou(dalšíPostavy) {
                Boj(útočník: hra.plán.naTahu, obránce: protivník).bojujte()
            }
        }
        while let možnost = hra.hráčNaTahu.vyberMožnost(pole.možnosti) {
            možnost.využij()
        }
    }
}
