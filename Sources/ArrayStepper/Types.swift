import SwiftUI

public struct ASValue<T: Hashable>: Hashable {
    private let id = UUID()
    var item: T
    
    public init(item: T) {
        self.item = item
    }
}

public struct ArrayStepperSection<T: Hashable>: Hashable {
    public let header: String
    public var items: [ASValue<T>]
    
    public init(header: String = "", items: [ASValue<T>]) {
        self.header = header
        self.items = items
    }
}

public class ArrayStepperValues<T: Hashable>: Hashable, ObservableObject {
    @Published public var values: [ASValue<T>]
    @Published public var selected: ASValue<T>
    @Published public var sections: [ArrayStepperSection<T>]
    
    public init(values: [ASValue<T>], selected: ASValue<T>, sections: [ArrayStepperSection<T>]? = nil) {
        self.values = values
        self.selected = selected
        
        if sections != nil {
            self.sections = sections!
        } else {
            self.sections = [ArrayStepperSection(items: values)]
        }
    }
    
    public static func == (lhs: ArrayStepperValues<T>, rhs: ArrayStepperValues<T>) -> Bool {
        return lhs.sections == rhs.sections
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(values)
        hasher.combine(selected)
        hasher.combine(sections)
    }
}

public enum SelectedCheck {
    case Fail,
         First,
         Append
}
