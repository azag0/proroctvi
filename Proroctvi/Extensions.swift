extension Array {
    subscript(circ i: Int) -> Element {
        return self[i >= 0 ? i % self.count : (i % self.count)+self.count]
    }
}

extension Dictionary {
    init(_ pairs: [Element]) {
        self.init()
        for (key, value) in pairs {
            self[key] = value
        }
    }
}

extension SequenceType {
    func map<T: Hashable, U>(@noescape transform: Generator.Element throws -> (T, U)) rethrows -> [T: U] {
        return [T: U](try map(transform))
    }
}