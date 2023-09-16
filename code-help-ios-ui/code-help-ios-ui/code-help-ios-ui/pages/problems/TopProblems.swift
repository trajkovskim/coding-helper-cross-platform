import SwiftUI

struct TopProblems: View {
    @EnvironmentObject private var webClient: ClientContainer

    var body: some View {        
        RequestDataFallback { problems, _ in
            HScrollView(title: "Top problems") {
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

struct RecentsView_Previews: PreviewProvider {
    static var previews: some View {
        AttachEnvironmentObjects {
            ScrollView {
                TopProblems()
            }
            .background(.primaryBackground)
        }
    }
}
