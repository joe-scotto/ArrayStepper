import SwiftUI

public struct ASValue<T: Hashable> {
    private var id = UUID()
    public let item: T
}

public struct ArrayStepper<T: Hashable>: View {
    @Binding var selected: T
    @Binding var values: [T]
    
    @State private var sections: [ArrayStepperSection<T>]
    
    @State private var timer: Timer? = nil
    @State private var isLongPressing = false
    @State private var index: Int = 0
    
    private var display: (T) -> String
    private let config: ArrayStepperConfig
    
    public init(
        selected: Binding<T>,
        values: Binding<[T]>,
        sections: Binding<[ArrayStepperSection<T>]>? = nil,
        display: @escaping (T) -> String = { "\($0)" },
        label: String? = nil,
        incrementSpeed: Double? = nil,
        decrementImage: ArrayStepperImage? = nil,
        incrementImage: ArrayStepperImage? = nil,
        disabledColor: Color? = nil,
        labelOpacity: Double? = nil,
        labelColor: Color? = nil,
        valueColor: Color? = nil,
        valuesAreUnique: Bool? = nil,
        selectedCheck: SelectedCheck? = nil,
        config: ArrayStepperConfig = ArrayStepperConfig()
    ) {
        // Compose config
        var config = config
            config.label = label ?? config.label
            config.incrementSpeed = incrementSpeed ?? config.incrementSpeed
            config.decrementImage = decrementImage ?? config.decrementImage
            config.incrementImage = incrementImage ?? config.incrementImage
            config.disabledColor = disabledColor ?? config.disabledColor
            config.labelOpacity = labelOpacity ?? config.labelOpacity
            config.labelColor = labelColor ?? config.labelColor
            config.valueColor = valueColor ?? config.valueColor
            config.valuesAreUnique = valuesAreUnique ?? config.valuesAreUnique
            config.selectedCheck = selectedCheck ?? config.selectedCheck
        
        // Assign bindings
        self._selected = selected
        self._values = values
        
        // Assign properties
        if let sections {
            self._sections = State(initialValue: sections.wrappedValue)
        } else {
            self._sections = State(initialValue: [ArrayStepperSection(header: config.label, items: _values.wrappedValue)])
        }

        self.display = display
        self.config = config
    }

    public var body: some View {
        HStack {
            LongPressButton(
                selected: $selected,
                values: $values,
                index: $index,
                config: config,
                image: config.decrementImage,
                action: .decrement
            )
            
            Spacer()
            
            VStack {
                NavigationLink(
                    display(selected),
                    destination: ArrayStepperList(
                        selected: $selected,
                        sections: sections,
                        display: display
                    )
                )
                .font(.system(size: 24, weight: .black))
                .foregroundColor(config.valueColor)
                
                if !config.label.isEmpty {
                    Text(config.label)
                        .font(.footnote)
                        .fontWeight(.light)
                        .foregroundColor(config.labelColor)
                        .opacity(config.labelOpacity)
                }
            }
            
            Spacer()
            
            LongPressButton(
                selected: $selected,
                values: $values,
                index: $index,
                config: config,
                image: config.incrementImage,
                action: .increment
            )
        }
        .onAppear {
            // Ensure values are unique
            if !config.valuesAreUnique {
                let uniqueValues = values.unique()
                
                if values != uniqueValues {
                    values = uniqueValues
                }
            }
            
            // Set initial value
            if let selectedIndex = values.firstIndex(of: selected) {
                index = selectedIndex
            } else {
                switch config.selectedCheck {
                    case .Fail : fatalError("Initial selected value not found for \(config.label) ArrayStepper, please confirm your selected value exists in your values array.")
                    case .First : index = 0
                    case .Append : values.append(selected); index = values.lastIndex
                }
            }
        }
        .onChange(of: selected) { _ in
            // Set index of selected from list
            if let updatedIndex = values.firstIndex(of: selected) {
                index = updatedIndex
            }
        }
        .onChange(of: values, perform: { _ in
            print("add")
            if sections.count == 1 {
                print("add 2")
                self.sections = [ArrayStepperSection(header: config.label, items: values)]
            }
        })
    }
}
