//
//  CodeHelpClient.swift
//  CodeHelpApi
//
//  Created by Vangel Trajkovski on 2.9.23.
//

import Foundation
import OpenAPIURLSession
import OpenAPIRuntime

enum CodeHelpApiError: Error {
    case CouldNotFetchProblems
    case ProblemNotFound
}

public struct CodeHelpClient {

    private var middlewares: [ClientMiddleware] = []
    private var client: (any APIProtocol)? = nil

    public init(with middleware: [ClientMiddleware]) {
        self.middlewares.append(contentsOf: middleware)
    }
    
    init(with middleware: [ClientMiddleware], _ client: some APIProtocol) {
        self.middlewares.append(contentsOf: middleware)
        self.client = client
    }

    public func getProblems() async throws -> [Components.Schemas.ProblemEntry] {
        let client = try createClient()
        let response = try await client.getProblemEntries(.init())

        switch response {
            case .ok(let okResponse):
                switch okResponse.body {
                    case .json(let json):
                        return json.problems
                }
            case .undocumented:
                print(response)
                throw CodeHelpApiError.CouldNotFetchProblems
        }
    }
    
    public func getLikedProblems() async throws -> [Components.Schemas.ProblemEntry] {
        let client = try createClient()
        let response = try await client.getLikedProblems(.init())
        
        switch response {
            case .ok(let okResponse):
                switch okResponse.body {
                    case .json(let json):
                        return json.problems
                }
            case .undocumented:
                print(response)
                throw CodeHelpApiError.CouldNotFetchProblems
        }
    }

    public func getProblemsTop10() async throws -> [Components.Schemas.ProblemByLikes] {
        let client = try createClient()
        let response = try await client.getTop10Problems(.init())

        switch response {
            case .ok(let okResponse):
                switch okResponse.body {
                    case .json(let json):
                        return json.problems
                }
            case .undocumented:
                print(response)
                throw CodeHelpApiError.CouldNotFetchProblems
        }
    }

    public func getProblem(id: Int) async throws -> Components.Schemas.ProblemByLikes {
        let client = try createClient()
        let response = try await client.getProblemEntry(.init(path: .init(id: id)))

        switch response {
            case .ok(let okResponse):
                switch okResponse.body {
                    case .json(let json):
                        return json
                }
            case .undocumented:
                print(response)
                throw CodeHelpApiError.ProblemNotFound
        }
    }

    public func like(problem id: Int) async throws {
        let client = try createClient()
        _ = try await client.toggleLikeProblemEntry(.init(path: .init(id: id)))
    }

    public func isLiked(problem id: Int) async throws -> Bool {
        let client = try createClient()
        let response = try await client.isProblemEntryLiked(.init(path: .init(id: id)))

        switch response {
            case .ok(let okResponse):
                switch okResponse.body {
                    case .json(let json):
                        return json
                }
            case .undocumented:
                print(response)
                throw CodeHelpApiError.CouldNotFetchProblems
        }
    }

    public func getCategories() async throws -> [Components.Schemas.Category] {
        let client = try createClient()
        let response = try await client.getCategories(.init())

        switch response {
            case .ok(let okResponse):
                switch okResponse.body {
                    case .json(let json):
                        return json.categories
                }
            case .undocumented:
                print(response)
                throw CodeHelpApiError.CouldNotFetchProblems
        }
    }

    public func createCategory(called name: String) async throws {
        let client = try createClient()
        let response = try await client.createCategories(.init(body: .json(.init(name: name))))

        switch response {
            case .noContent(_):
                return
            case .undocumented:
                print(response)
                throw CodeHelpApiError.CouldNotFetchProblems
        }
    }

    public func getSubmissions(forProblemId id: Int) async throws -> [Components.Schemas.SubmissionEntry] {
        let client = try createClient()
        let response = try await client.getSubmissions(.init(body: .json(.init(problemId: id))))

        switch response {
            case .ok(let okResponse):
                switch okResponse.body {
                    case .json(let json):
                        return json.submissions
                }
            case .undocumented:
                print(response)
                throw CodeHelpApiError.CouldNotFetchProblems
        }
    }

    public func submit(forProblem id: Int, writenIn language: String, withCode code: String ) async throws -> String {
        let client = try createClient()
        let response = try await client.createSubmissionsEntry(.init(body: .json(
            .init(
                value1: .init(language: language, code: code),
                value2: .init(problemId: id)
            )
        )))

        switch response {
            case .noContent(let noContentResponse):
                switch noContentResponse.body {
                    case .text(let text):
                        return text
                }
            case .undocumented:
                print(response)
                throw CodeHelpApiError.CouldNotFetchProblems
        }
    }

    public func getContests() async throws -> [Components.Schemas.ContestEntry] {
        let client = try createClient()
        let response = try await client.getContestEntries(.init())

        switch response {
            case .ok(let okResponse):
                switch okResponse.body {
                    case .json(let json):
                        return json.contests
                }
            case .undocumented:
                print(response)
                throw CodeHelpApiError.CouldNotFetchProblems
        }
    }

    public func getContest(withId id: Int) async throws -> Components.Schemas.ContestEntry {
        let client = try createClient()
        let response = try await client.getContestEntry(.init(path: .init(id: id)))

        switch response {
            case .ok(let okResponse):
                switch okResponse.body {
                    case .json(let json):
                        return json
                }
            case .undocumented:
                print(response)
                throw CodeHelpApiError.CouldNotFetchProblems
        }
    }

    public func getProblem(inContest contest: Int, withId id: Int) async throws -> Components.Schemas.ContestProblem {
        let client = try createClient()
        let response = try await client.getContestProblem(.init(path: .init(contestId: contest, problemId: id)))

        switch response {
            case .ok(let okResponse):
                switch okResponse.body {
                    case .json(let json):
                        return json
                }
            case .undocumented:
                print(response)
                throw CodeHelpApiError.CouldNotFetchProblems
        }
    }

    public func setScore(inContestId contest: Int, forProblemId problem: Int) async throws {
        let client = try createClient()
        let _ = try await client.setContestProblemScore(.init(path: .init(contestId: contest, problemId: problem)))
    }

    public func runCode(forProblem id: Int, writenIn language: String , withCode data: String) async throws -> String {
        let client = try createClient()
        let response = try await client.runCode(.init(body: .json(.init(problemId: id, language: language, code: data))))

        switch response {
            case .ok(let okResponse):
                switch okResponse.body {
                    case .text(let text):
                        return text
                }
            case .undocumented:
                print(response)
                throw CodeHelpApiError.CouldNotFetchProblems
        }
    }

    public func getUserStatistics() async throws -> Components.Schemas.UserStatistics {
        let client = try createClient()
        let response = try await client.getStatistics(.init())

        switch response {
            case .ok(let okResponse):
                switch okResponse.body {
                    case .json(let json):
                        return json
                }
            case .undocumented:
                print(response)
                throw CodeHelpApiError.CouldNotFetchProblems
        }
    }

    private func createClient() throws -> APIProtocol {
        if let client = client {
            return client
        }
        
        return Client(
            serverURL: try Servers.server1(),
            transport: URLSessionTransport(),
            middlewares: middlewares
        )
    }
}
