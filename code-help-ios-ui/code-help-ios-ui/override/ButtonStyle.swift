//
//  ButtonStyle.swift
//  code-help-ios-ui
//
//  Created by Vangel Trajkovski on 5.8.23.
//

import SwiftUI


extension ButtonStyle where Self == LightBorderedButtonStyle {
    static var lightBordered: Self {
        return .init()
    }
}

struct LightBorderedButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(5)
            .padding(.horizontal, 5)
            .font(.body.bold())
            .foregroundColor(configuration.isPressed ? .primary.opacity(0.5) : .primary)
            .background(
                Capsule()
                    .fill(
                        configuration.isPressed
                        ? Color.accentColor.opacity(0.10)
                        : Color.accentColor.opacity(0.25)
                    )
            )
    }
}


extension ButtonStyle where Self == InvertedBorderedButtonStyle {
    static var invertedBordered: Self {
        return .init()
    }
}

struct InvertedBorderedButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(5)
            .background(configuration.isPressed ? .secondaryBackground.opacity(0.5) : .secondaryBackground)
            .foregroundColor(configuration.isPressed ? Color.accentColor.opacity(0.5) : .accentColor)
            .cornerRadius(5)
    }
}

extension ButtonStyle where Self == TabButtonStyle {
    static var tabbed: Self {
        return .init()
    }
    
    static func tabbed(_ dissabled: Bool?) -> Self {
        return .init(disabled: dissabled ?? false)
    }
}

struct TabButtonStyle: ButtonStyle {
    var disabled: Bool = false
    
    func makeBody(configuration: Configuration) -> some View {
        let primaryButtonColor = Color(uiColor: .tintColor)
        
        configuration.label
            .padding(5)
            .padding(.horizontal, 5)
            .font(.body.bold())
            .foregroundColor(
                !disabled
                ? configuration.isPressed ? .primary.opacity(0.5) : .primary.opacity(0.7)
                : primaryButtonColor
            )
            .background(.clear)
    }
}
