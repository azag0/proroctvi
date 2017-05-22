/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

var hráči: [Hráč] = (1...2).map { _ in HloupýHráč() }
hráči[0].postava = Postava(povolání: .Druid)
hráči[1].postava = Postava(povolání: .Zaklínačka)
let hra = Hra(hráči: hráči)
print(hra.plán)
for _ in 1...6 {
    hra.proveďKolo()
    print(hra.plán)
}