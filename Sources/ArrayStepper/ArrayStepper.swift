import SwiftUI

public struct ArrayStepper<T: Equatable>: View {
    @Binding var selected: T
    @Binding var values: Array<T>

    
    @State private var timer: Timer? = nil
    @State private var isLongPressing = false
    
    private let use: KeyPath<T, String>?
    private let label: String
    
    private var index: Int {
        values.firstIndex(of: selected) ?? 0
    }

    public init(selected: Binding<T>, values: Binding<Array<T>>, use: KeyPath<T, String>? = nil, label: String = "") {
        self._selected = selected
        self._values = values
        self.use = use
        self.label = label
    }

    public var body: some View {
        HStack {
            longPressButton(
                image: "minus.circle.fill",
                action: {
                    if selected != values.first {
                        selected = values[index - 1]
                    }
                },
                condition: selected == values.first,
                longAction: .decrement
            )
        
            Spacer()
            
            VStack {
//                Text(aperture.value)
////                Text("\(selected as! String)")
//                if let use = use {
//                    Text(selected[keyPath: use])
//                } else {
                    Text(String(describing: selected))
//                }
                
                Text(label)//.textFieldStepperLabel()
            }
            
            Spacer()
            
            longPressButton(
                image: "plus.circle.fill",
                action: {
                    if !isLongPressing {
                        if selected != values.last {
                            selected = values[index + 1]
                        }
                    } else {
                        invalidateLongPress()
                    }
                },
                condition: selected == values.last,
                longAction: .increment
            )
        }
    }
    
    func longPressButton(image: String, action: @escaping () -> Void, condition: Bool, longAction: Action) -> some View {
        return Button(action: action, label: {
            Image(systemName: image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 35)
        })
//        .textFieldStepperDisabled(condition)
        .simultaneousGesture(
            LongPressGesture(minimumDuration: 0.25).onEnded {
                startTimer($0, action: longAction)
            }
        )
    }
    
    enum Action {
        case decrement,
             increment
    }
    
    /**
     * Decreases or increases the doubleValue
     */
    func updateSelected(_ action: Action) {
        switch action {
            case .decrement :
                selected = values[index - 1]
            case .increment :
                selected = values[index + 1]
            }
    }
    
    /**
     * Starts the long press
     */
    func startTimer(_ value: LongPressGesture.Value, action: Action) {
        isLongPressing = true
        timer = Timer.scheduledTimer(withTimeInterval: 0.25, repeats: true) { _ in
            // Perform action regardless of actual value
            updateSelected(action)
            
            // If value after action is outside of constraints, stop long press
            if values[index] == values.first || values[index] == values.last {
                invalidateLongPress()
            }
        }
    }
    
    /**
     * Stops the long press
     */
    func invalidateLongPress() {
        isLongPressing = false
        timer?.invalidate()
    }
    
    func convertToString(_ input: T) -> String {
        if let string = selected as? String {
            return string
        }
        
        if let int = selected as? Int {
            return String(int)
        }
        
        if let double = selected as? Double {
            return String(double)
        }
        
        return ""
    }
}
