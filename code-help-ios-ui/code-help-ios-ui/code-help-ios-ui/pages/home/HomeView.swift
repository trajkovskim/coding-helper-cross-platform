import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationTitleView(title: "Home") {
            ScrollView {
                VStack {
                    ActiveContests()
                    Spacer(minLength: 30)
                    TopProblems()
                }.padding(.vertical)
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        AttachEnvironmentObjects {
            HomeView()
        }
    }
}
