import SwiftUI

public struct ArrayStepperSet<T: Hashable>: Hashable {
    let header: String
    let items: [T]
    
    public init(header: String, items: [T]) {
        self.header = header
        self.items = items
    }
}

struct ArrayStepperList<T: Hashable>: View {
    @Environment(\.dismiss) var dismiss
    
    @Binding var selected: T
    
    var sets: [ArrayStepperSet<T>]
    var display: (T) -> String
    
    init(selected: Binding<T>, sets: [ArrayStepperSet<T>], display: @escaping (T) -> String) {
        self._selected = selected
        self.sets = sets
        self.display = display
    }
    
    var body: some View {
        List {
            ForEach(sets, id: \.self) { set in
                Section(set.header) {
                    
                    ForEach(set.items, id: \.self) { item in
                        Button(action: {
                            selected = item
                            print(item)
                            dismiss()
                        }) {
                            HStack {
                                Text(display(item))
                                
                                Spacer()
                                
                                if selected == item {
                                    Image(systemName: "checkmark")
                                }
                            }
                        }
                    }
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle(Text(display(selected)))
    }
}
