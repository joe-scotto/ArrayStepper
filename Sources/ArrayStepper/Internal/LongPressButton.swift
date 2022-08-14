import SwiftUI

public struct LongPressButton<T: Equatable>: View {
    private var index: Int {
        return values.firstIndex(of: selected) ?? 0
    }
    
    @Binding var selected: T
    @Binding var values: Array<T>
    
    @State private var timer: Timer? = nil
    @State private var isLongPressing = false
    
    enum Action {
        case decrement,
             increment
    }
    
    let config: ArrayStepperConfig
    let image: ArrayStepperImage
    let action: Action
    
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
        .foregroundColor(!shouldDisable() ? image.color : config.disabledColor)
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
                shouldDisable = selected == values.first
            case .increment:
                shouldDisable = selected == values.last
        }
        
        return shouldDisable
    }
    
    /**
     * Starts the long press
     */
    func startTimer(_ value: LongPressGesture.Value, action: Action) {
        isLongPressing = true
        timer = Timer.scheduledTimer(withTimeInterval: config.incrementSpeed, repeats: true) { _ in
            // Perform action regardless of actual value
            updateSelected()
            
            // If value after action is outside of constraints, stop long press
            if values[index] == values.first || values[index] == values.last {
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
                newIndex = index - 1
            case .increment :
                newIndex = index + 1
            }
        
        // Verify the new index will be in the values array
        selected = values.indices.contains(newIndex) ? values[newIndex] : values[index]
    }
}
