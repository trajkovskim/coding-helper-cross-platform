import SwiftUI

struct NavigationTitleView<Content: View>: View {
    var title: String = ""
    
    @ViewBuilder var content: () -> Content
    
    var body: some View {
        NavigationStack {
            StyledNavigationBar(title: title) {
                content().toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button() {
                            print("clicked")
                        } label: {
                            Image(systemName: "list.bullet.clipboard.fill")
                        }.foregroundColor(.accentColor)
                    }
                }
            }
        }
    }
}

struct NavigationTitleView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
