import SwiftUI

struct ArrayStepperList<T: Hashable>: View {
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var values: ArrayStepperValues<T>
    
    var display: (T) -> String
    
    init(values: ArrayStepperValues<T>,
         display: @escaping (T) -> String
    ) {
        self.values = values
        self.display = display
    }
    
    var body: some View {
        List {
            ForEach(values.sections, id: \.self) { section in
                Section(section.header) {
                    
                    ForEach(section.items, id: \.self) { item in
                        Button(action: {
                            print(item)
                            values.selected = item
                            dismiss()
                        }) {
                            HStack {
                                Text(display(item))
                                
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
        .listStyle(InsetGroupedListStyle())
        .navigationTitle(Text(display(values.selected)))
        .onAppear { 
//            print("ArrayStepperList: \($sections[0].items.count)")
        }
    }
}
