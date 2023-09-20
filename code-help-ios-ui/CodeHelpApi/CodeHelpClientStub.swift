//
//  CodeHelpClientStub.swift
//  CodeHelpApi
//
//  Created by Vangel Trajkovski on 8.9.23.
//

import Foundation
import OpenAPIURLSession
import OpenAPIRuntime

public class CodeHelpClientStub {
    public static func create(_ middlewares: [ClientMiddleware]) -> CodeHelpClient {
        .init(with: middlewares, MockClient())
    }
}

struct MockClient: APIProtocol {
    
    private var data = CodeHelpDataStub()
    
    public init() {
    }
    
    func getProblemEntries(_ input: Operations.getProblemEntries.Input) async throws -> Operations.getProblemEntries.Output {
        .ok(.init(body: .json(.init(problems: data.problems.values.map { p in p.toResponse() }))))
    }
    
    func getLikedProblems(_ input: Operations.getLikedProblems.Input) async throws -> Operations.getLikedProblems.Output {
        .ok(.init(body: .json(.init(problems: data.getLikedProblems()))))
    }
    
    func getTop10Problems(_ input: Operations.getTop10Problems.Input) async throws -> Operations.getTop10Problems.Output {
        .ok(.init(body: .json(.init(problems: data.getTop10Problems()))))
    }
    
    func createProblemEntry(_ input: Operations.createProblemEntry.Input) async throws -> Operations.createProblemEntry.Output {
        .noContent(.init())
    }
    
    func getProblemEntry(_ input: Operations.getProblemEntry.Input) async throws -> Operations.getProblemEntry.Output {
        if let response = data.getProblem(byId: input.path.id) {
            return .ok(.init(body: .json(response)))
        }
        
        return .undocumented(statusCode: 404, .init())
    }
    
    func editProblemEntry(_ input: Operations.editProblemEntry.Input) async throws -> Operations.editProblemEntry.Output {
        .noContent(.init())
    }
    
    func deleteProblemEntry(_ input: Operations.deleteProblemEntry.Input) async throws -> Operations.deleteProblemEntry.Output {
        .noContent(.init())
    }
    
    public func toggleLikeProblemEntry(_ input: Operations.toggleLikeProblemEntry.Input) async throws -> Operations.toggleLikeProblemEntry.Output {
        if (data.likeProblem(withId: input.path.id)) {
            return .undocumented(statusCode: 400, .init())
        }
        return .noContent(.init())
    }
    
    func isProblemEntryLiked(_ input: Operations.isProblemEntryLiked.Input) async throws -> Operations.isProblemEntryLiked.Output {
        .ok(.init(body: .json(data.isLiked(problemId: input.path.id))))
    }
    
    func getCategories(_ input: Operations.getCategories.Input) async throws -> Operations.getCategories.Output {
        .ok(.init(body: .json(.init(categories: data.categories))))
    }
    
    func createCategories(_ input: Operations.createCategories.Input) async throws -> Operations.createCategories.Output {
        .noContent(.init())
    }
    
    func getSubmissions(_ input: Operations.getSubmissions.Input) async throws -> Operations.getSubmissions.Output {
        .ok(.init(body: .json(.init(submissions: data.getSubmissions()))))
    }
    
    func createSubmissionsEntry(_ input: Operations.createSubmissionsEntry.Input) async throws -> Operations.createSubmissionsEntry.Output {
        switch input.body {
            case .json(let json):
                data.createSubmissions(submissionRequest: json)
                return .noContent(.init(body: .text("All tests passed")))
            case .none:
                return .noContent(.init(body: .text("Test cases failed")))
        }
    }
    
    func getContestEntries(_ input: Operations.getContestEntries.Input) async throws -> Operations.getContestEntries.Output {
        .ok(.init(body: .json(.init(contests: data.getContests()))))
    }
    
    func createContestEntry(_ input: Operations.createContestEntry.Input) async throws -> Operations.createContestEntry.Output {
        .noContent(.init())
    }
    
    func getContestEntry(_ input: Operations.getContestEntry.Input) async throws -> Operations.getContestEntry.Output {
        if let contest = data.getContest(byId: input.path.id) {
            return .ok(.init(body: .json(contest)))
        }
        
        return .undocumented(statusCode: 404, .init())
    }
    
    func createContestProblemEntry(_ input: Operations.createContestProblemEntry.Input) async throws -> Operations.createContestProblemEntry.Output {
        .noContent(.init())
    }
    
    func editContestEntry(_ input: Operations.editContestEntry.Input) async throws -> Operations.editContestEntry.Output {
        .noContent(.init())
    }
    
    func deleteContestEntry(_ input: Operations.deleteContestEntry.Input) async throws -> Operations.deleteContestEntry.Output {
        .noContent(.init())
    }
    
    func startContest(_ input: Operations.startContest.Input) async throws -> Operations.startContest.Output {
        .noContent(.init())
    }
    
    func closeContest(_ input: Operations.closeContest.Input) async throws -> Operations.closeContest.Output {
        .noContent(.init())
    }
    
    func getContestProblem(_ input: Operations.getContestProblem.Input) async throws -> Operations.getContestProblem.Output {
        if let problem = data.getContestProblem(forProblemId: input.path.problemId) {
            return .ok(.init(body: .json(problem)))
        }
        return .undocumented(statusCode: 404, .init())
    }
    
    func deleteContestProblem(_ input: Operations.deleteContestProblem.Input) async throws -> Operations.deleteContestProblem.Output {
        .noContent(.init())
    }
    
    func setContestProblemScore(_ input: Operations.setContestProblemScore.Input) async throws -> Operations.setContestProblemScore.Output {
        .noContent(.init())
    }
    
    func runCode(_ input: Operations.runCode.Input) async throws -> Operations.runCode.Output {
        .ok(.init(body: .text("All tests passed")))
    }
    
    func getStatistics(_ input: Operations.getStatistics.Input) async throws -> Operations.getStatistics.Output {
        .ok(.init(body: .json(data.userStatistics.toResponse())))
    }
    
}

class CodeHelpDataStub {
    
    private var nextSubmissionId = 0;
    
    var isLiked: Set<Int>
    var problems: [Int: Problem]
    var contests: [Int: Contest]
    var contestProblems: [Int: [Problem]]
    var contestsProblems: [Int: Problem]
    var userStatistics = UserStatistic(easy: 4, medium: 4, hard: 8, solved: 10)
    
    var submissions: [Int: Submission]
    var problemSubmissions: [Int: [Submission]]
    
    
    var categories: [Components.Schemas.Category]
    
    init() {
        let (problems, contests, contestProblems, categories) = Self.createData()
        
        self.categories = categories
        self.problems = problems.reduce([:]) { result, problem in
            result.merging([problem.id: problem]) { lp, rp in  rp }
        }
        self.contests = contests.reduce([:]) { result, contest in
            result.merging([contest.id: contest]) { lp, rp in  rp }
        }
        
        self.contestsProblems = contestProblems.reduce([:]) { result, contestProblem in
            result.merging([contestProblem.id:contestProblem]) { lp, rp in rp }
        }
        
        self.contestProblems = contestProblems.reduce([:]) { result, contestProblem in
            result.merging([contestProblem.contestId!: [contestProblem]]) { lp, rp in lp + rp }
        }
        
        self.isLiked = Set()
        self.submissions = [:]
        self.problemSubmissions = [:]
    }
    
    
    func getAllProblems() -> [Components.Schemas.ProblemEntry] {
        self.problems.values
            .map { p in p.toResponse() }
    }
    
    func getTop10Problems() -> [Components.Schemas.ProblemByLikes] {
        self.problems.values
            .sorted { lp, rp in lp.likes > rp.likes }
            .map { p in p.toLikesResponse() }
    }
    
    func getLikedProblems() -> [Components.Schemas.ProblemEntry] {
        self.problems.values
            .filter { problem in isLiked.contains(problem.id) }
            .map { problem in problem.toResponse() }
    }
    
    func getProblem(byId id: Int) -> Components.Schemas.ProblemByLikes? {
        (problems[id] ?? contestsProblems[id])?.toLikesResponse()
    }
    
    func likeProblem(withId id: Int) -> Bool {
        guard var problem = self.problems[id] else {
            return false
        }
        
        if self.isLiked.contains(id) {
            self.isLiked.remove(id)
            self.problems[id]!.likes -= 1
        } else {
            self.isLiked.insert(id)
            self.problems[id]!.likes += 1
        }
        
        return true
    }
    
    func isLiked(problemId id: Int) -> Bool {
        self.isLiked.contains(id)
    }
    
    func getSubmissions() -> [Components.Schemas.SubmissionEntry] {
        self.submissions.values.map { submission in submission.toResponse() }
    }
    
    func createSubmissions(submissionRequest request: Components.Schemas.SubmissionReqBody) {
        let submission: Submission = .init(
            id: nextSubmissionId,
            code: request.value1.code,
            language: request.value1.language,
            timeSubmitted: .now,
            status: .ACCEPTED
        )
        
        self.submissions[submission.id] = submission
        
        if self.problemSubmissions[request.value2.problemId] == nil {
            self.problemSubmissions[request.value2.problemId] = []
        }
        
        self.problemSubmissions[request.value2.problemId]!.append(submission)
        
        nextSubmissionId += 1
    }
    
    func getContests() -> [Components.Schemas.ContestEntry] {
        self.contests.values.map { contest in contest.toResponse(contestProblems[contest.id] ?? []) }
    }
    
    func getContest(byId id: Int) -> Components.Schemas.ContestEntry? {
        self.contests[id]?.toResponse(self.contestProblems[id] ?? [])
    }
    
    func getContestProblem(forProblemId problemId: Int) -> Components.Schemas.ContestProblem? {
        self.contestsProblems[problemId]?.toContestResponse()
    }
    
    static func createData() -> ([Problem], [Contest], [Problem], [Components.Schemas.Category]) {
        let categories: [Components.Schemas.Category] = [
            .init(name: "Arrays"), .init(name: "Objects"), .init(name: "Other")
        ]
        
        let problems: [Problem] = Array(0..<20).map { id in
                .init(
                    id: id,
                    contestId: nil,
                    name: "Two sum",
                    difficulty: Components.Schemas.Difficulty.allCases.randomElement() ?? .EASY,
                    category: categories.randomElement() ?? .init(name: "Arrays"),
                    likes: 10,
                    markdown: Self.markdown,
                    code: Self.code,
                    score: 100
                )
        }
        
        let contests: [Contest] = Array(0..<20).map { id in
                .init(
                    id: id,
                    image: nil,
                    name: "Contest1",
                    startsOn: .now,
                    status: .allCases.randomElement() ?? .OPEN,
                    duration: "1H20M"
                )
        }
        
        var from = 20
        var to = 40
        
        let contestProblems: [Problem] = contests.flatMap { contest in
            let contestProblems: [Problem] = Array(from..<to).map { id in
                    .init(
                        id: id,
                        contestId: contest.id,
                        name: "Two sum",
                        difficulty: Components.Schemas.Difficulty.allCases.randomElement() ?? .EASY,
                        category: categories.randomElement() ?? .init(name: "Arrays"),
                        likes: 10,
                        markdown: Self.markdown,
                        code: Self.code,
                        score: 100
                    )
            }
            
            from += 20
            to += 20
            
            return contestProblems
        }
        
        return (problems, contests, contestProblems, categories)
    }
    
    struct UserStatistic {
        let easy: Int
        let medium: Int
        let hard: Int
        let solved: Int
        
        func toResponse() -> Components.Schemas.UserStatistics {
            .init(
                solved: self.solved,
                easy: self.easy,
                medium: self.medium,
                hard: self.hard
            )
        }
    }
    
    struct Submission: Identifiable {
        let id: Int
        let code: String
        let language: String
        let timeSubmitted: Date
        let status: Components.Schemas.SubmissionStatus
        
        func toResponse() -> Components.Schemas.SubmissionEntry {
            .init(
                value1: .init(language: self.language, code: self.code),
                value2: .init(id: self.id,timeSubmitted: self.timeSubmitted.description, status: self.status)
            )
        }
    }
    
    struct Problem: Identifiable {
        let id: Int
        let contestId: Int?
        let name: String
        let difficulty: Components.Schemas.Difficulty
        let category: Components.Schemas.Category
        var likes: Int
        let markdown: String
        let code: String
        let score: Int?
        
        func toResponse() -> Components.Schemas.ProblemEntry {
            .init(
                value1: .init(category: self.category, title: self.name, difficulty: self.difficulty, markdown: self.markdown),
                value2: .init(id: self.id, starterCode: self.code)
            )
        }
        
        func toLikesResponse() -> Components.Schemas.ProblemByLikes {
            .init(
                value1: .init(
                    value1: .init(category: self.category, title: self.name, difficulty: self.difficulty, markdown: self.markdown),
                    value2: .init(id: self.id, starterCode: self.code)
                ),
                value2: .init(likes: self.likes))
        }
        
        func toContestResponse() -> Components.Schemas.ContestProblem {
            .init(problem: self.toResponse(), score: self.score!)
        }
    }
    
    struct Contest: Identifiable {
        let id: Int
        let image: String?
        let name: String
        let startsOn: Date
        let status: Components.Schemas.ContestStatus
        let duration: String
        
        func toResponse(_ problems: [Problem]) -> Components.Schemas.ContestEntry {
            .init(
                value1: .init(name: self.name, duration: self.duration, startsOn: self.startsOn.ISO8601Format()),
                value2: .init(id: self.id, status: self.status,  problems: problems.map { problem in problem.toContestResponse() })
            )
        }
    }
    
    static let code = "//returns array\nconst twoSum = (nums, target) => {\n\n};\n"
    static let markdown = "---\nGiven an array of integers *nums* and an integer target, return indices of the two numbers such that they add up to target.\nYou may assume that each input would have exactly one solution, and you may not use the same element twice.\nYou can return the answer in any order.\n---\n**Example 1:**\n```\nInput: nums = [2,7,11,15], target = 9\nOutput: [0,1]\nExplanation: Because nums[0] + nums[1] == 9, we return [0, 1].\n```\n**Example 2:**\n```\nInput: nums = [3,2,4], target = 6\nOutput: [1,2]\n```\n**Example 3:**\n```\nInput: nums = [3,3], target = 6\nOutput: [0,1]\n```\n**Constraints:**\n- 2 <= nums.length <= 104\n- 109 <= nums[i] <= 109\n- 109 <= target <= 109\n- **Only one valid answer exists.**"
}
