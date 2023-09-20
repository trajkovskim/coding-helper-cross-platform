import SwiftUI

struct Category {
    let name: String
}

enum Difficulty {
    case EASY
    case MEDIUM
    case HARD
}

struct ProblemEntry: Identifiable {
    let id: String = UUID().uuidString
    let title: String
    let category: Category? = nil
    let difficulty: Difficulty? = nil
}

private let dummyData = [
    ProblemEntry(title: "Problem1"),
    ProblemEntry(title: "Problem2"),
    ProblemEntry(title: "Problem3"),
    ProblemEntry(title: "Problem3"),
    ProblemEntry(title: "Problem3"),
    ProblemEntry(title: "Problem3"),
    ProblemEntry(title: "Problem3"),
    ProblemEntry(title: "Problem3"),
    ProblemEntry(title: "Problem4")
]

struct ActiveContests: View {
    @EnvironmentObject private var webClient: ClientContainer

    var body: some View {
        RequestDataFallback { contests, refresh in
            HScrollView(title: "Active") {
                if !contests.isEmpty {
                    
                    ForEach(contests, id: \.value2.id!) { contest in
                        NavigationLink {
                            ContestDetailsView(contestId: contest.value2.id!)
                        } label: {
                            HTile(title: contest.value1.name, imageName: LanguageIcon.randomIcon())
                        }
                        .foregroundColor(.primary)
                        .fontWeight(.bold)
                    }
                } else {
                    Text("There are not active contests at the moment, check back later.")
                        .font(.caption)
                        .frame(height: 150)
                }
            }
        } suplier: {
            try await webClient.codeHelpClient.getContests().filter { contest in
                contest.value2.status == .STARTED
            }
        }
    }
}

struct RecentProblems_Previews: PreviewProvider {
    static var previews: some View {
        AttachStubEnvironmentObjects {
            NavigationStack {
                ScrollView {
                    ActiveContests()
                }
                .background(.primaryBackground)
            }
        }
    }
}
