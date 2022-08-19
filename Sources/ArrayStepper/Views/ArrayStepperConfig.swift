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
    var valuesAreUnique: Bool
    var valuesContainValue: Bool
    var selectedCheck: SelectedCheck
    
    public init (
        label: String = "",
        incrementSpeed: Double = 0.25,
        decrementImage: ArrayStepperImage = ArrayStepperImage(systemName: "minus.circle.fill"),
        incrementImage: ArrayStepperImage = ArrayStepperImage(systemName: "plus.circle.fill"),
        disabledColor: Color = Color(UIColor.lightGray),
        labelOpacity: Double = 1.0,
        labelColor: Color = .primary,
        valueColor: Color = .primary,
        valuesAreUnique: Bool = false,
        valuesContainValue: Bool = false,
        selectedCheck: SelectedCheck = .Fail
    ) {
        self.label = label
        self.incrementSpeed = incrementSpeed
        self.decrementImage = decrementImage
        self.incrementImage = incrementImage
        self.disabledColor = disabledColor
        self.labelOpacity = labelOpacity
        self.labelColor = labelColor
        self.valueColor = valueColor
        self.valuesAreUnique = valuesAreUnique
        self.valuesContainValue = valuesContainValue
        self.selectedCheck = selectedCheck
    }
}
