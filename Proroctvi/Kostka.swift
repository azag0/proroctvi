/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

import Foundation

func random(maximum: Int) -> Int {
    return numericCast(arc4random_uniform(numericCast(maximum)))
}

class Kostka {
    func hoď() -> Int {
        return random(6)+1
    }
}