import SwiftUI

public struct ASValue<T: Hashable>: Hashable {
    public let id = UUID()
    public var item: T
    
    public init(_ item: T) {
        self.item = item
    }
}

public struct ASSection<T: Hashable>: Hashable {
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
    @Published public var sections: [ASSection<T>]
    @Published public var index: Int
    
    private init(selected: ASValue<T>, values: [ASValue<T>], sections: [ASSection<T>], index: Int) {
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
        var index: Int
        var values = values
        var asValues: [ASValue<T>]
        
        // Find in values array and error check
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
        
        // Don't cast if they already are ASValue
        if !(values is [ASValue<T>]) || !(selected is ASValue<T>) {
            asValues = values.asCast()
        } else {
            asValues = values as! [ASValue<T>]
        }
        
        // Initialize
        self.init(
            selected: asValues[index],
            values: asValues,
            sections: [ASSection(items: asValues)],
            index: index
        )
    }
    
    public convenience init(
        selected: T,
        sections: [(header: String, items: [T])],
        missingCheck: MissingCheck = .Fail
    ) {
        // Values must all be the same type... check
        var values = [T]()
        var formattedSections = [ASSection<T>]()
        var index: Int
        var asValues: [ASValue<T>]

        for section in sections {
            // section items need to be stored as asvalues and raw in order to sort them.
            
            formattedSections.append(ASSection(header: section.header, items: section.items.asCast()))
            values.append(contentsOf: section.items)
        }

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

        if !(values is [ASValue<T>]) || !(selected is ASValue<T>) {
            asValues = values.asCast()
        } else {
            asValues = values as! [ASValue<T>]
        }
        
        self.init(selected: asValues[index], values: asValues, sections: formattedSections, index: index)
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

public enum MissingCheck {
    case Fail,
         First,
         Append
}
