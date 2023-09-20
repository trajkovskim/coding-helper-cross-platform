//
//  Shared.swift
//  code-help-ios-ui
//
//  Created by Vangel Trajkovski on 5.8.23.
//

import SwiftUI

struct OptionProp<Content: View, T: Hashable>: View {
    @Binding var selected: T
    var options: [T]
    var title: String
    
    
    @ViewBuilder var content: (T) -> Content
    var close: (() -> Void)?

    var body: some View {
        HStack {
            Text(title)
            Spacer()
            Picker("Select", selection: $selected) {
                ForEach(options, id: \.self) { option in
                    content(option)
                }
            }
            .pickerStyle(.menu)
            .buttonStyle(.bordered)
            Button {
                close?()
            } label: {
                Image(systemName: "xmark")
            }
        }
        .frame(maxWidth: .infinity)
    }
}
