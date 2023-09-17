//
//  SettingsModel.swift
//  code-help-ios-ui
//
//  Created by Martin Trajkovski on 8.9.23.
//

import SwiftUI
import CodeEditor

extension String {
    func toLanguage() -> Language? {
        Language(rawValue: self)
    }
    
    func toAccentColor() -> AccentColor? {
        AccentColor(rawValue: self)
    }
    func toEditorTheme() -> EditorTheme? {
        EditorTheme(rawValue: self)
    }
}

enum Language: String, CaseIterable, Identifiable {
    var id: Self { self }
    
    case java = "java"
    case javascript = "javascript"
    case python = "python"
    
    private static let editorLanguage: [Language:CodeEditor.Language] = [
        .java: .java,
        .javascript: .javascript,
        .python: .python
    ]
    
    func toEditorThemeName() -> CodeEditor.Language {
        Self.editorLanguage[self] ?? .javascript
    }
}


enum AccentColor: String, CaseIterable, Identifiable {
    var id: Self { self }
    
    case original = "Default"
    case blue = "Blue"
    case red = "Red"
    case green = "Green"
    case orange = "Orange"
    case indigo = "Indigo"
    case pink = "Pink"
    case cyan = "Cyan"
    case purple = "Purple"
    case mint = "Mint"
    case teal = "Teal"
    
    private static let color: [AccentColor:Color] = [
        .original: .accentColor,
        .blue: .blue,
        .red: .red,
        .green: .green,
        .orange: .orange,
        .indigo: .indigo,
        .pink: .pink,
        .cyan: .cyan,
        .purple: .purple,
        .mint: .mint,
        .teal: .teal,
    ]
    
    func toColor() -> Color {
        Self.color[self] ?? .accentColor
    }
}

enum EditorTheme: String, CaseIterable, Identifiable {
    var id: Self { self }
    
    case agate = "Agate"
    case ocean = "Occean"
    case pojoaque = "Pojoaque"
    case SavannaLight = "Savanna Dark"
    case SavannaDark = "Savanna Light"
    
    private static let editorThemeName: [EditorTheme:CodeEditor.ThemeName] = [
        .agate: .agate,
        .ocean: .ocean,
        .pojoaque: .pojoaque,
        .SavannaLight: .atelierSavannaLight,
        .SavannaDark: .atelierSavannaDark
    ]
    
    func toEditorThemeName() -> CodeEditor.ThemeName {
        Self.editorThemeName[self] ?? .agate
    }
}
