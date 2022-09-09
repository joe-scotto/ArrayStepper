import SwiftUI

public struct ArrayStepperConfig {
    var label: String
    var incrementSpeed: Double
    var decrementImage: ArrayStepperImage
    var incrementImage: ArrayStepperImage
    var disabledColor: Color
    var labelOpacity: Double
    var labelColor: Color
    var valueColor: Color
    
    public init (
        label: String = "",
        incrementSpeed: Double = 0.25,
        decrementImage: ArrayStepperImage = ArrayStepperImage(systemName: "minus.circle.fill"),
        incrementImage: ArrayStepperImage = ArrayStepperImage(systemName: "plus.circle.fill"),
        disabledColor: Color = Color(UIColor.lightGray),
        labelOpacity: Double = 1.0,
        labelColor: Color = .primary,
        valueColor: Color = .primary
    ) {
        self.label = label
        self.incrementSpeed = incrementSpeed
        self.decrementImage = decrementImage
        self.incrementImage = incrementImage
        self.disabledColor = disabledColor
        self.labelOpacity = labelOpacity
        self.labelColor = labelColor
        self.valueColor = valueColor
    }
}
