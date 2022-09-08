import SwiftUI

public struct ASValue<T: Hashable>: Hashable {
    private let id = UUID()
    public var item: T
    
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
    
    public init(selected: T, values: [T], sections: [ArrayStepperSection<T>]? = nil) {
        // take selected and store it for later
        // Find first instance of selected
        // values can be nil but then you must provide sections
        // sections will be formatted into values if no values provided
    
        
        
        let selectedIndex = values.firstIndex(of: selected) ?? 0
        let asValues = values.asCast()
        
        
        self.values = asValues
        self.selected = asValues[selectedIndex]
        self.sections = sections != nil ? sections! : [ArrayStepperSection(items: asValues)]
    }
    
    public static func == (lhs: ArrayStepperValues<T>, rhs: ArrayStepperValues<T>) -> Bool {
        return lhs.sections == rhs.sections
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(values)
        hasher.combine(selected)
        hasher.combine(sections)
    }
    
    private static func conformValues(_ values: [T], selected: T) -> [ASValue<T>] {
        // get first index of selected
        // abide by selectedcheck rules
//        if let selectedIndex = values.firstIndex(of: selected) {
//            selected =
//        }
        
        if let asValues = values as? [ASValue<T>] {
            return asValues
        } else {
            return values.asCast()
        }
    }
}

public enum SelectedCheck {
    case Fail,
         First,
         Append
}
