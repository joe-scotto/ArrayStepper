public extension Array where Element: Hashable {
    func asCast() -> [ASValue<Element>]{
        self.map({
            ASValue($0)
        })
    }
}
