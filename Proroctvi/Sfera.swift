/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

class NižšíStrážce: Stvůra {
}

class VyššíStrážce: Stvůra {
}

class Artefakt: Předmět {
}

struct Sféra {
    let nižšíStrážce: NižšíStrážce
    let vyššíStrážce: VyššíStrážce
    let artefakt: Artefakt
    var odkryto = 0
    
    mutating func odkryj() {
        if odkryto < 3 { odkryto += 1 }
    }
    
    init(nižší: NižšíStrážce, vyšší: VyššíStrážce, artefakt: Artefakt) {
        nižšíStrážce = nižší
        vyššíStrážce = vyšší
        self.artefakt = artefakt
    }
}