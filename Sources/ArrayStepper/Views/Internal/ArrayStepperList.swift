import SwiftUI

struct ArrayStepperList<T: Hashable>: View {
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var values: ArrayStepperValues<T>
    
    let display: (T) -> String
    
    var body: some View {
        List {
            ForEach(values.sections, id: \.self) { section in
                Section(section.header) {
                    ForEach(section.items, id: \.self) { item in
                        Button(action: {
                            values.selected.item = item
                            dismiss()
                        }) {
                            HStack {
                                Text(display(item))
                                
                                Spacer()
                                
                                if values.selected.item == item {
                                    Image(systemName: "checkmark")
                                }
                            }
                        }
                    }
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle(Text(display(values.selected.item)))
    }
}
