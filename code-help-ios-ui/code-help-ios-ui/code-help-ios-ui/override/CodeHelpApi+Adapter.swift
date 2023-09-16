//
//  CodeHelpApi+Adapter.swift
//  code-help-ios-ui
//
//  Created by Vangel Trajkovski on 6.9.23.
//

import Foundation
import CodeHelpApi

extension Components.Schemas.UserStatistics {
    
    func toStat() -> [Stat] {
        [
            .init(name: "Solved", value: self.solved.description),
            .init(name: "Easy", value: self.easy.description),
            .init(name: "Medium", value: self.medium.description),
            .init(name: "Hard", value: self.hard.description)
        ]
    }
}

extension Components.Schemas.SubmissionEntry {
    
    func toAtempt() -> ProblemAtempt {
        .init(
            id: self.value2.id!,
            code: self.value1.code,
            language: Language(rawValue: self.value1.language)!,
            time: self.value2.timeSubmitted
        )
    }
}

extension Components.Schemas.ProblemByLikes {
    
    func toProblemDetailsModel(contestId: Int? = nil) -> ProblemDetails {
        let problemEntry = self.value1
        let problemBase = problemEntry.value1
        let problemEntryAdditional = problemEntry.value2
        let problemAdditional = self.value2
        
        return .init(
            id: problemEntryAdditional.id!,
            contestId: contestId,
            name: problemBase.title,
            description: nil,
            dificulty: problemBase.difficulty.description.lowercased().capitalized,
            category: problemBase.category?.name,
            likes: problemAdditional.likes.description,
            markdown: problemBase.markdown,
            code: problemEntryAdditional.starterCode
        )
    }
}

extension Components.Schemas.ProblemEntry {
    func toDiscoverData() -> ProblemDiscoverData {
        .init(
            id: self.value2.id!,
            image: nil,
            title: self.value1.title,
            subtitle: self.value1.difficulty.description.lowercased().capitalized
        )
    }
    
    func toSavedProblem() -> SavedProblemModel {
        .init(id: self.value2.id!, name: self.value1.title, contestId: nil)
    }
}

extension Components.Schemas.ContestProblem {
    func toContestRow(contestId: Int) -> ContestRowData {
        .init(
            id: self.problem.value2.id!,
            contestId: contestId,
            name: self.problem.value1.title,
            difficulty: self.problem.value1.difficulty.description.lowercased().capitalized,
            score: self.score
        )
    }
}

extension Components.Schemas.ContestEntry {
    
    func toDiscoverData() -> ContestDiscoverData {
        .init(
            id: self.value2.id!,
            image: LanguageIcon.randomIcon(),
            title: self.value1.name,
            subtitle: self.value1.startsOn,
            duration: self.value1.duration
        )
    }
}

extension Components.Schemas.ContestEntry {
    func toDetailsModel() -> ContestDetails {
        let contestBase = self.value1
        let contestEntry = self.value2
        
        return .init(
            id: contestEntry.id!,
            name: contestBase.name,
            description: nil,
            duration: contestBase.duration.lowercased().capitalized,
            status: contestEntry.status ?? .OPEN,
            statusDescription: contestEntry.status?.description.lowercased().capitalized ?? "none",
            problems: contestEntry.problems
        )
    }
}
