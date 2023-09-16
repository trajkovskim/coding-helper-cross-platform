//
//  LearnViewActions.swift
//  code-help-ios-ui
//
//  Created by Vangel Trajkovski on 3.8.23.
//

import SwiftUI

struct ProblemViewActions: View {
    var body: some View {
        TopActions {
            NavigationLink {
               ProblemHistoryView()
            } label: {
                TopActionItem(title: "Recent", image: "clock.arrow.circlepath")
            }
            NavigationLink {
                ContestDiscover()
            } label: {
                TopActionItem(title: "Contests", image: "trophy.fill")
            }
            NavigationLink {
                ProblemDiscover()
            } label: {
                TopActionItem(title: "Discover", image: "globe.desk.fill")
            }
        }
    }
}

struct LearnViewActions_Previews: PreviewProvider {
    static var previews: some View {
        AttachEnvironmentObjects {
            NavigationStack {
                ScrollView {
                    ProblemViewActions()
                }
                .background(.secondaryBackground)
            }
        }
    }
}
