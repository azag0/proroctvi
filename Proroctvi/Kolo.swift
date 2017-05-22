/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

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
