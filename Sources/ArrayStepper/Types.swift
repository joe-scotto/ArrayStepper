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
    
    public init(
        selected: T,
        values: [T],
        sections: [ArrayStepperSection<T>]? = nil
//        config: ArrayStepperConfig
    ) {
        // take selected and store it for later
        // Find first instance of selected
        // values can be nil but then you must provide sections
        // sections will be formatted into values if no values provided
    
        
        
        var index: Int
        var values = values

        
        if let selectedIndex = values.firstIndex(of: selected) {
            index = selectedIndex
        } else {
            index = 0
//             values.append(selected)
//            index = values.endIndex - 1
            
//            switch config.selectedCheck {
//                case .Fail : fatalError("Initial selected value not found for \(config.label) ArrayStepper, please confirm your selected value exists in your values array.")
//                case .First : index = 0
//                case .Append :
//                    values.append(selected)
//                    index = values.endIndex - 1
//            }
        }
        
        let asValues = values.asCast()
        
        // Don't cast if they already are ASValue
//        if !(values is [ASValue<T>]) || !(selected is ASValue<T>) {
//            asValues = values.asCast()
//        } else {
//            asValues = values as! [ASValue<T>]
//        }
        
        // Set properties
        

        
        self.values = asValues
        self.selected = asValues[index]
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
}

public enum SelectedCheck {
    case Fail,
         First,
         Append
}
