//
//  StyledNavigationBar.swift
//  code-help-ios-ui
//
//  Created by Vangel Trajkovski on 3.8.23.
//

import SwiftUI

struct StyledNavigationBar<Content: View>: View {
    var title: String = ""
    
    @ViewBuilder var content: () -> Content

    var body: some View {
        content()
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Color.clear, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .background(.primaryBackground)
    }
}

struct StyledNavigationBar_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
