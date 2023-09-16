//
//  Model.swift
//  code-help-ios-ui
//
//  Created by Vangel Trajkovski on 6.9.23.
//

import Foundation

struct ProblemAtempt: Identifiable {
    let id: Int
    let code: String
    let language: Language
    let time: String
}

struct ProblemDiscoverModel {
    let title: String
    let subtitle: String
    let image: String?
}

struct ProblemDiscoverData: Identifiable {
    let id: Int
    let image: String?
    let title: String
    let subtitle: String
}

struct ProblemDetails: Identifiable {
    let id: Int
    let contestId: Int?
    let name: String
    let description: String?
    let dificulty: String
    let category: String?
    let likes: String
    let markdown: String?
    let code: String
}
