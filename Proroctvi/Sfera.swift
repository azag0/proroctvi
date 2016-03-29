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