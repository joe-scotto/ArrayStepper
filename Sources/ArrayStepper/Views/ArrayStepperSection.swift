import SwiftUI

public struct ArrayStepperSection<T: Hashable>: Hashable {
    let header: String
    let items: [T]
    
    public init(header: String, items: [T]) {
        self.header = header
        self.items = items
    }
}
