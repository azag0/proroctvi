var hráči: [Hráč] = (1...2).map { _ in HloupýHráč() }
hráči[0].postava = Postava(povolání: .Druid)
hráči[1].postava = Postava(povolání: .Zaklínačka)
let hra = Hra(hráči: hráči)
print(hra.plán)
for _ in 1...6 {
    hra.proveďKolo()
    print(hra.plán)
}