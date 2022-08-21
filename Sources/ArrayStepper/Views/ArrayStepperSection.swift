import SwiftUI

public struct ArrayStepperSection<T: Hashable>: Hashable {
    public let header: String
    public var items: [T]
    
    public init(header: String = "", items: [T]) {
        self.header = header
        self.items = items
    }
}

public class ArrayStepperValues<T: Hashable>: Hashable, ObservableObject {
    @Published public var values: [T]
    @Published public var selected: T
    @Published public var sections: [ArrayStepperSection<T>]
    
    public init(
        values: [T],
        selected: T,
        sections: [ArrayStepperSection<T>]
    ) {
        self.values = values
        self.selected = selected
        self.sections = sections
    }
    
    public static func == (lhs: ArrayStepperValues<T>, rhs: ArrayStepperValues<T>) -> Bool {
        lhs.sections == rhs.sections
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(sections)
    }
    
}
