import SwiftUI

struct ProblemView: View {
    let spacing: Double = 20
    var body: some View {
        NavigationTitleView(title: "Problems") {
            ScrollView {
                VStack {
                    Spacer(minLength: spacing)
                    ProblemViewActions()
                    Spacer(minLength: spacing)
                    ActiveContests()
                    Spacer(minLength: spacing)
                    RecomendedProblems()
                    Spacer(minLength: spacing)
                }
                .padding(.vertical, 20)
            }
        }
    }
}

struct LearnView_Previews: PreviewProvider {
    static var previews: some View {
        AttachEnvironmentObjects {
            ProblemView()
        }
    }
}
