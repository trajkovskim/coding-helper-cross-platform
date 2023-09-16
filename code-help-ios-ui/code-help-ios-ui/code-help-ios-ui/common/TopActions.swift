import SwiftUI

struct TopActions<Content: View>: View {
    @ViewBuilder var content: () -> Content
    
    var body: some View {
        HStack {
            content()
        }
        .padding(.horizontal)
        .padding(.bottom)
    }
}

struct TopActions_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            TopActions {
                TopActionItem(title: "Recent", image: "clock.arrow.circlepath")
                TopActionItem(title: "Contests", image: "trophy.fill")
                TopActionItem(title: "Discover", image: "globe.desk.fill")
                .foregroundColor(.primary)
            }
        }.background(.primaryBackground)
    }
}
