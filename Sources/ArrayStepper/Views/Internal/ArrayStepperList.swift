import SwiftUI

struct ArrayStepperList<T: Hashable>: View {
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var values: ArrayStepperValues<T>
    
    @Binding var index: Int
    
    let display: (T) -> String
    
    var body: some View {
        List {
            ForEach(values.sections, id: \.self) { section in
                Section(section.header) {
                    ForEach(section.items, id: \.self) { item in
                        Button(action: {
                            values.selected = item
                            
                            if let selectedIndex = values.values.firstIndex(of: item) {
                                index = selectedIndex
                            }
                            
                            dismiss()
                        }) {
                            HStack {
                                Text(display(item.item))
                                
                                Spacer()
                                
                                if values.selected == item {
                                    Image(systemName: "checkmark")
                                }
                            }
                        }
                    }
                }
            }
        }
        .onAppear {
            print("Shown")
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle(Text(display(values.selected.item)))
    }
}
