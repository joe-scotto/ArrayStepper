import SwiftUI

public struct ArrayStepper<T: Hashable>: View {
    @ObservedObject var values: ArrayStepperValues<T>
    
    @State private var timer: Timer? = nil
    @State private var isLongPressing = false
    @State private var index: Int = 0
    
    private let display: (T) -> String
    private let config: ArrayStepperConfig
    
    public init(
        values: ArrayStepperValues<T>,
        display: @escaping (T) -> String = { "\($0)" },
        label: String? = nil,
        incrementSpeed: Double? = nil,
        decrementImage: ArrayStepperImage? = nil,
        incrementImage: ArrayStepperImage? = nil,
        disabledColor: Color? = nil,
        labelOpacity: Double? = nil,
        labelColor: Color? = nil,
        valueColor: Color? = nil,
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
            config.selectedCheck = selectedCheck ?? config.selectedCheck
        
        // Assign properties
        self.values = values
        
        self.display = display
        self.config = config
//        self.values.config = config
    
        // If [ASValue] don't check / cast
    }

    public var body: some View {
        HStack {
            LongPressButton(
                values: values,
                index: $index,
                config: config,
                image: config.decrementImage,
                action: .decrement
            )
            
            Spacer()
            
            VStack {
                NavigationLink(
                    display(values.selected.item),
                    destination: ArrayStepperList(values: values, index: $index, display: display)
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
                values: values,
                index: $index,
                config: config,
                image: config.incrementImage,
                action: .increment
            )
        }
        .onChange(of: values.selected) { _ in
            // Set index of selected from list
            if let updatedIndex = values.values.firstIndex(of: values.selected) {
                index = updatedIndex
            }
        }
    }
}
