import Foundation

protocol Dummy {
    static func dummy() -> Self
}

extension Array where Element: Dummy {
    static func dummies(quantity: Int = Int.random(in: 1...10)) -> [Element] {
        var values = [Element]()
        for _ in 1...quantity {
            values.append(Element.dummy())
        }
        return values
    }
}
