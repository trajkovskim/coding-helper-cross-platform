//
//  ProblemHistoryView.swift
//  code-help-ios-ui
//
//  Created by Martin Trajkovski on 7.9.23.
//

import SwiftUI


struct ProblemHistoryView: View {
    @Environment(\.managedObjectContext) var context
    
    var body: some View {
        StyledNavigationBar {
            let historyProblems = context.getProblemHistory()
            if !historyProblems.isEmpty {
                List {
                    ForEach(historyProblems) { hsitoryProblem in
                        NavigationLink {
                            ProblemDetailsView(problemId: hsitoryProblem.id.toInt(), contestId: hsitoryProblem.contestId?.toInt(), shouldSave: false)
                        } label: {
                            VStack(alignment: .leading) {
                                Text(hsitoryProblem.name ?? "none")
                                    .bold()
                                Text(hsitoryProblem.date?.description ?? "")
                                    .font(.caption)
                            }
                            .padding(.vertical, 1)
                        }
                    }
                }
                .scrollContentBackground(.hidden)
            } else {
                VStack {
                    Text("No recent history")
                        .font(.caption)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
    }
}


struct ProblemHistoryView_Preview: PreviewProvider {
    static var previews: some View {
        AttachStubEnvironmentObjects {
            NavigationStack {
                ProblemHistoryView()
            }
        }
    }
}
