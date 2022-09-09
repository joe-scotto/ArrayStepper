import SwiftUI

struct ArrayStepperList<T: Hashable>: View {
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var asValues: ArrayStepperValues<T>
    
    let display: (T) -> String
    
    var body: some View {
        List {
            ForEach(asValues.sections, id: \.self) { section in
                Section(section.header) {
                    ForEach(section.items, id: \.self) { item in
                        Button(action: {
                            asValues.selected = item
                            
                            if let selectedIndex = asValues.values.firstIndex(of: item) {
                                asValues.index = selectedIndex
                            }
                            
                            dismiss()
                        }) {
                            HStack {
                                Text(display(item.item))
                                
                                Spacer()
                                
                                if asValues.selected == item {
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
        .navigationTitle(Text(display(asValues.selected.item)))
    }
}
