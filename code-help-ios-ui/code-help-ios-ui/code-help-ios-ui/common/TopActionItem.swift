import SwiftUI

struct TopActionItem: View {
    var title: String
    var image: String
    
    
    
    var body: some View {
        VStack {
            Image(systemName: image)
                .resizable()
                .scaledToFit()
                .padding(.horizontal)
                .foregroundColor(.primary)
            Text(title)
                .bold()
        }
        .frame(maxWidth: .infinity, maxHeight: 90)
        .padding(.vertical)
        .background(.secondaryBackground)
        .cornerRadius(10)
    }
}

struct TopActionItem_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            TopActions {
                TopActionItem(title: "Recent", image: "clock.arrow.circlepath")
                TopActionItem(title: "Contests", image: "trophy.fill")
                NavigationLink {
                    ProblemDiscover()
                } label: {
                    TopActionItem(title: "Discover", image: "globe.desk.fill")
                }
                .foregroundColor(.primary)
            }
        }.background(.primaryBackground)
    }
}
