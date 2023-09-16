//
//  Color.swift
//  code-help-ios-ui
//
//  Created by Vangel Trajkovski on 29.8.23.
//

import SwiftUI


extension Color {
    
    static var primaryBackground: Color {
        Color(uiColor:.systemGray6.dark(.systemBackground))
    }
    static var secondaryBackground: Color {
        Color(uiColor:.systemBackground.dark(.systemGray6))
    }
}

extension ShapeStyle where Self == Color {
    static var primaryBackground: Color { .primaryBackground }
    static var secondaryBackground:  Color { .secondaryBackground }
}


extension UIColor {
    func dark(_ color: UIColor) -> UIColor {
        return UIColor { ui in ui.userInterfaceStyle == .dark ? color : self}
    }
}
