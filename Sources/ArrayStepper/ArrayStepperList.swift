import SwiftUI

struct ArrayStepperList<T: Hashable>: View {
    @Environment(\.dismiss) var dismiss
    
    @Binding var selected: T
    @Binding var values: Array<T>
    
    var display: (T) -> String
    
    var body: some View {
        List {
            ForEach(values, id: \.self) { value in
                Button(action: {
                    selected = value
                    dismiss()
                }) {
                    HStack {
                        Text(display(value))
                        
                        Spacer()
                        
                        if selected == value {
                            Image(systemName: "checkmark")
                        }
                    }
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle(Text(display(selected)))
    }
}
