import SwiftUI

extension View {
    func onAppearOrChange<V: Equatable>(of: V, action: @escaping () -> Void) -> some View {
        return self
            .onChange(of: of) { _ in
                action()
            }
            .onAppear {
                action()
            }
    }
}
