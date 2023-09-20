import SwiftUI
import CodeHelpApi

struct RecomendedProblems: View {
    @EnvironmentObject private var webClient: ClientContainer

    var body: some View {
        RequestDataFallback { problems, _ in
            HScrollView(title: "Recomended") {
                ForEach(problems, id: \.value1.value2.id) {problem in
                    NavigationLink {
                        ProblemDetailsView(problemId: problem.value1.value2.id!)
                    } label: {
                        HTile(title: problem.value1.value1.title, imageName: LanguageIcon.randomIcon())
                    }
                    .foregroundColor(.primary)
                    .fontWeight(.bold)
                }
            }
        } suplier: {
            try await webClient.codeHelpClient.getProblemsTop10()
        }
    }
}

struct RecomendedProblems_Previews: PreviewProvider {
    static var previews: some View {
        AttachEnvironmentObjects {
            ScrollView {
                RecomendedProblems()
            }
            .background(.primaryBackground)
        }
    }
}
