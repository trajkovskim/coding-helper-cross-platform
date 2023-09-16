//
//  LanguageIcon.swift
//  code-help-ios-ui
//
//  Created by Vangel Trajkovski on 8.9.23.
//

import Foundation

enum LanguageIcon: String, CaseIterable {
    case c = "c"
    case cpp = "cpp"
    case csharp = "csharp"
    case go = "go"
    case java = "java"
    case javascript = "javascript"
    case kotlin = "kotlin"
    case python = "python"
    case rust = "rust"
    case swift = "swift"
    case typescript = "typescript"
    
    static func randomIcon() -> String {
        return LanguageIcon.allCases.randomElement()?.rawValue ?? ""
    }
}
