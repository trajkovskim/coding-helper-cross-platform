//
//  ContestDetailsView.swift
//  code-help-ios-ui
//
//  Created by Vangel Trajkovski on 6.9.23.
//

import SwiftUI
import CodeHelpApi



struct ContestDetails: Identifiable {
    let id: Int
    let name: String
    let description: String?
    let duration: String
    let status: Components.Schemas.ContestStatus
    let statusDescription: String
    let problems: [Components.Schemas.ContestProblem]
}

struct ContestRowData: Identifiable {
    let id: Int
    let contestId: Int
    let name: String
    let difficulty: String
    let score: Int
}

struct ContestDetailsView: View {
    @EnvironmentObject private var webClient: ClientContainer

    private let sectionSpacing: Double = 40
    private let cornerRadius: Double = 10.0
    let contestId: Int
    
    var body: some View {
        StyledNavigationBar(title: "Problem") {
            VStack {
                RequestDataFallback { contest, refresh in
                    ContestDetailsInfo(
                        contest: contest.toDetailsModel(),
                        sectionSpacing: sectionSpacing,
                        cornerRadius: cornerRadius
                    )
                } suplier: {
                    try await webClient.codeHelpClient.getContest(withId: contestId)
                }
            }
            .padding(.vertical)
            .background(.primaryBackground)
        }
    }
}

struct ContestDetailsInfo: View {
    @EnvironmentObject private var webClient: ClientContainer
        
    let contest: ContestDetails
    var sectionSpacing = 40.0
    var cornerRadius = 10.0
    
    var body: some View {
        ContestInfo(contest: contest, cornerRadius: cornerRadius)
        if let description = contest.description {
            Spacer(minLength: sectionSpacing)
            ContestDescription(description: description, cornerRadius: cornerRadius)
        }
        switch contest.status {
            case .OPEN, .undocumented:
                EmptyStatusView(description: "Contest not started yet")
                Spacer()
            case .STARTED:
                ContestProblemsView(contestId: contest.id, problems: contest.problems)
            case .CLOSED:
                EmptyStatusView(description: "Contest is closed")
                ContestProblemsView(contestId: contest.id, problems: contest.problems)
        }
    }
}

struct ContestInfo: View {
    
    @State var selected = "java"
    private let options = ["java", "javascript", "python"]
    
    let contest: ContestDetails
    var cornerRadius = 10.0
    
    var body: some View {
        HStack {
            VStack {
                HStack {
                    Image("csharp")
                        .resizable()
                        .scaledToFit()
                        .padding(20)
                        .frame(maxWidth: 120)
                    Spacer()
                    VStack {
                        VStack {
                            Text("Status: \(contest.statusDescription)")
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Text("Duration: \(contest.duration)")
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .frame(width: 130)
                    }
                    .padding(.trailing)
                }
                Spacer().frame(height: 20)
                HStack {
                    Text(contest.name)
                        .font(Font.system(size: 18))
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                }.padding(.horizontal)
                Spacer().frame(height: 20)
            }
        }
        .padding(.bottom)
        .background(.secondaryBackground)
        .cornerRadius(cornerRadius)
        .padding(.horizontal)
    }
}

struct EmptyStatusView: View {
    var description: String
    var cornerRadius = 10.0
    
    var body: some View {
        HStack {
            Text(description)
                .font(.subheadline)
                .frame(maxWidth: .infinity, alignment: .center)
        }
        .padding(.all)
        .background(.secondaryBackground)
        .cornerRadius(cornerRadius)
        .padding(.horizontal)
    }
}

struct ContestDescription: View {
    var description: String
    var cornerRadius = 10.0
    
    var body: some View {
        HStack {
            VStack {
                Text("Description: ")
                    .font(Font.system(size: 17))
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text(description)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .frame(minHeight: 100, alignment: .top)
        .padding(.all)
        .background(.secondaryBackground)
        .cornerRadius(cornerRadius)
        .padding(.horizontal)
    }
}

struct ContestProblemsView: View {
    let contestId: Int
    let problems: [Components.Schemas.ContestProblem]
    
    var body: some View {
        if !problems.isEmpty {
            List {
                ForEach(problems, id: \.id) { problem in
                    ContestProblemRow(problem: problem.toContestRow(contestId: contestId))
                }
            }
            .scrollContentBackground(.hidden)
        } else {
            EmptyStatusView(description: "No problems")
            Spacer()
        }
    }
}

struct ContestProblemRow: View {
    let problem: ContestRowData
    
    var body: some View {
        HStack {
            NavigationLink {
                ProblemDetailsView(problemId: problem.id)
            } label: {
                VStack(alignment: .leading) {
                    Text(problem.name)
                    Text(problem.difficulty)
                        .font(.caption)
                }
            }
        }
    }
}


struct ContestDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        AttachStubEnvironmentObjects {
            ContestDetailsView(contestId: 1)
        }
    }
}
