/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

protocol Bojující {}

class Boj {
    var útočník: Bojující
    var obránce: Bojující
    
    init(útočník: Bojující, obránce: Bojující) {
        self.útočník = útočník
        self.obránce = obránce
    }
    
    func bojujte() -> Výsledek {
        return .Remíza
    }
}

enum Výsledek {
    case Prohra
    case Remíza
    case Vítězství
}