public extension Array where Element: Hashable {
    func asCast() -> [ASValue<Element>]{
        self.map({
            ASValue(item: $0)
        })
    }
}
