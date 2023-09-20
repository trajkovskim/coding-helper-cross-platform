//
//  SavedProblems.swift
//  code-help-ios-ui
//
//  Created by Martin Trajkovski on 8.9.23.
//

import SwiftUI
import CodeHelpApi
import Authentication

struct SavedProblemModel: Identifiable {
    let id: Int
    let name: String
    let contestId: Int?
}

struct SavedProblemsView: View {
    @EnvironmentObject private var webClient: ClientContainer
    @EnvironmentObject private var authenticationService: AuthenticationService
    
    @State private var likedProblemTask: Task<Void, Never>? = nil
    @State private var problems: [SavedProblemModel] = []
    
    private func requestLikedProblems() {
        if authenticationService.state.isAuthorized() {
            likedProblemTask?.cancel()
            likedProblemTask = Task.detached {
                do {
                    let response = try await webClient.codeHelpClient.getLikedProblems()
                        .map { problem in problem.toSavedProblem() }
                    await MainActor.run {
                        problems = response
                    }
                } catch {
                    print(error)
                }
                await likedProblemTask?.cancel()
            }
        }
    }
    
    var body: some View {
        StyledNavigationBar {
            if !problems.isEmpty {
                List {
                    ForEach(problems) { problem in
                        NavigationLink {
                            ProblemDetailsView(
                                problemId: problem.id,
                                contestId: problem.contestId,
                                shouldSave: false)
                        } label: {
                            VStack(alignment: .leading) {
                                Text(problem.name)
                                    .bold()
                            }
                            .padding(.vertical, 1)
                        }
                    }
                }
                .scrollContentBackground(.hidden)
            } else {
                VStack {
                    Text("No liked problems")
                        .font(.caption)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .onAppear {
            requestLikedProblems()
        }
        .onDisappear {
            likedProblemTask?.cancel()
        }
    }
}

struct SavedProblems_Previews: PreviewProvider {
    static var previews: some View {
        AttachStubEnvironmentObjects {
            SavedProblemsView()
        }
    }
}

