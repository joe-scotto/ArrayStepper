import SwiftUI

struct LongPressButton<T: Hashable>: View {
    @ObservedObject var asValues: ArrayStepperValues<T>
    
    @State private var timer: Timer? = nil
    @State private var isLongPressing = false
    
    enum Action {
        case decrement,
             increment
    }
    
    private let config: ArrayStepperConfig
    private let image: ArrayStepperImage
    private let action: Action
    
    init(
        asValues: ArrayStepperValues<T>,
        config: ArrayStepperConfig,
        image: ArrayStepperImage,
        action: Action
    ) {
        self.asValues = asValues
        self.config = config
        self.image = image
        self.action = action
    }
    
    public var body: some View {
        Button(action: {
            !isLongPressing ? updateSelected() : invalidateLongPress()
        }) {
            image
        }
        .simultaneousGesture(
            LongPressGesture(minimumDuration: 0.25).onEnded {
                startTimer($0, action: action)
            }
        )
        .foregroundColor(shouldDisable() ? config.disabledColor : image.color)
        .disabled(shouldDisable())
    }
    
    /**
     * Stops the long press
     */
    private func invalidateLongPress() {
        isLongPressing = false
        timer?.invalidate()
    }
    
    /**
     * Check if button should be enabled or not based on the action
     */
    private func shouldDisable() -> Bool {
        var shouldDisable = false
        
        switch action {
            case .decrement:
                shouldDisable = asValues.index == 0
            case .increment:
                shouldDisable = asValues.values[asValues.index] == asValues.values.last
        }
        
        return shouldDisable
    }
    
    /**
     * Starts the long press
     */
    private func startTimer(_ value: LongPressGesture.Value, action: Action) {
        isLongPressing = true
        timer = Timer.scheduledTimer(withTimeInterval: config.incrementSpeed, repeats: true) { _ in
            // Perform action regardless of actual value
            updateSelected()
            
            // If value after action is outside of constraints, stop long press
            if asValues.index == 0 || asValues.values[asValues.index] == asValues.values.last {
                invalidateLongPress()
            }
        }
    }
    
    /**
     * Decreases or increases the selected value
     */
    private func updateSelected() {
        var newIndex: Int
        
        switch action {
            case .decrement :
                newIndex = asValues.index - 1
            case .increment :
                newIndex = asValues.index + 1
            }
    
        // Verify the new index will be in the values array
        if asValues.values.indices.contains(newIndex) {
            asValues.index = newIndex
            asValues.selected = asValues.values[asValues.index]
        }
    }
}
