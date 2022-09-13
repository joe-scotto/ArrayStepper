import SwiftUI

public struct ASValue<T: Hashable>: Hashable {
    public let id = UUID()
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
    @Published public var index: Int
    
    private init(selected: ASValue<T>, values: [ASValue<T>], sections: [ArrayStepperSection<T>], index: Int) {
        self.selected = selected
        self.values = values
        self.sections = sections
        self.index = index
    }
    
    public convenience init(
        selected: T,
        values: [T],
        missingCheck: MissingCheck = .Fail
    ) {
        // take selected and store it for later
        // Find first instance of selected
        // values can be nil but then you must provide sections
        // sections will be formatted into values if no values provided
    
        
        // convert to asvalue array
        // Find by ID in that array
        
        
        var index: Int
        var values = values

        
        if let selectedIndex = values.firstIndex(of: selected) {
            index = selectedIndex
        } else {
            switch missingCheck {
                case .Fail : fatalError("Initial selected value not found for ArrayStepper, please confirm your selected value exists in your values array.")
                case .First : index = 0
                case .Append :
                    values.append(selected)
                    index = values.endIndex - 1
            }
        }
        
        let asValues = values.asCast()
        
        // Don't cast if they already are ASValue
//        if !(values is [ASValue<T>]) || !(selected is ASValue<T>) {
//            asValues = values.asCast()
//        } else {
//            asValues = values as! [ASValue<T>]
//        }
        
        // Set properties
        
        self.init(
            selected: asValues[index],
            values: asValues,
            sections: [ArrayStepperSection(items: asValues)],
            index: index
        )
    }
    
//    public convenience init(
//        selected: T,
//        sections: [ArrayStepperSection<T>]? = nil,
//        missingCheck: MissingCheck = .Fail
//    ) {
//
//    }
    
    public static func == (lhs: ArrayStepperValues<T>, rhs: ArrayStepperValues<T>) -> Bool {
        return lhs.sections == rhs.sections
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(values)
        hasher.combine(selected)
        hasher.combine(sections)
    }
}

public enum MissingCheck {
    case Fail,
         First,
         Append
}
