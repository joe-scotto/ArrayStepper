import SwiftUI

struct ArrayStepperList<T: Hashable>: View {
    @Environment(\.dismiss) var dismiss
    
    @Binding var selected: T
    @Binding var sections: [ArrayStepperSection<T>]
    
    let display: (T) -> String
    
    init(selected: Binding<T>, sections: Binding<[ArrayStepperSection<T>]>, display: @escaping (T) -> String) {
        self._selected = selected
        self._sections = sections
        self.display = display
    }
    
    var body: some View {
        List {
            ForEach(sections, id: \.self) { section in
                Section(section.header) {
                    ForEach(section.items, id: \.self) { item in
                        Button(action: {
                            selected = item
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
