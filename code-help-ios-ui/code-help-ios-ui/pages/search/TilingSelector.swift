//
//  TilingSelector.swift
//  code-help-ios-ui
//
//  Created by Vangel Trajkovski on 6.8.23.
//

import SwiftUI

enum TilingOption: String, CaseIterable {
    case list = "tile"
    case grid = "grid"
}

struct TilingSelector: View {
    @Binding var selected: TilingOption
    
    var body: some View {
        HStack {
            Image(systemName: "square.righthalf.fill")
                .resizable()
                .frame(width: 20, height: 20)
                .aspectRatio(1, contentMode: .fit)
                .scaledToFit()
                .offset(x: 10)
            Picker("Select", selection: $selected) {
                ForEach(TilingOption.allCases, id: \.self) { option in
                    HStack {
                        Text(option.rawValue)
                    }
                }
            }
            
            .pickerStyle(.menu)
        }
        .padding(0)
        .frame(maxWidth: .infinity)
        .frame(height: 30)
        .background(.secondaryBackground)
        .cornerRadius(5)
    }
}

private struct DiscoverData: Identifiable {
    let id = UUID()
    let image = "csharp"
    let title = "Some Problem"
    let subtitle = "easy"
}

struct TilingSelector_Previews: PreviewProvider {
    
    static var previews: some View {
        AttachStubEnvironmentObjects {
            ProblemDiscover()
        }
    }
}
