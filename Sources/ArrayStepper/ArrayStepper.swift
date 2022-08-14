import SwiftUI

// 1. Config init()
//

public struct ArrayStepper<T: Equatable>: View  {
    @Binding var selected: T
    @Binding var values: Array<T>
    
    
    @State private var timer: Timer? = nil
    @State private var isLongPressing = false
    @State private var index: Int = 0
    
    private let use: KeyPath<T, String>?
    private let config: ArrayStepperConfig
    
    public init(
        selected: Binding<T>,
        values: Binding<Array<T>>,
        use: KeyPath<T, String>? = nil,
        label: String? = nil,
        incrementSpeed: Double? = nil,
        decrementImage: ArrayStepperImage? = nil,
        incrementImage: ArrayStepperImage? = nil,
        disabledColor: Color? = nil,
        labelOpacity: Double? = nil,
        labelColor: Color? = nil,
        valueColor: Color? = nil,
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
        
        // Assign properties
        self._selected = selected
        self._values = values
        self.use = use
        self.config = config
    }
    
    public var body: some View {
        HStack {
            LongPressButton(
                selected: $selected,
                values: $values,
                config: config,
                image: config.decrementImage,
                action: .decrement
            )
            
            Spacer()
            
            VStack {
                if let use = use,
                   let keyPathExists = selected[keyPath: use] {
                    Text(keyPathExists).multilineTextAlignment(.center)
                        .font(.system(size: 24, weight: .black))
                        .foregroundColor(config.valueColor)
                } else {
                    Text(String(describing: selected)).multilineTextAlignment(.center)
                        .font(.system(size: 24, weight: .black))
                        .foregroundColor(config.valueColor)
                }
                
                if let label = config.label {
                    Text(label)
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
                config: config,
                image: config.incrementImage,
                action: .increment
            )
        }
    }
}
