//
//  UserSettingsView.swift
//  code-help-ios-ui
//
//  Created by Martin Trajkovski on 7.9.23.
//

import SwiftUI

struct UserSettingsView: View {
    @Environment(\.managedObjectContext) private var context
    @EnvironmentObject private var accentColorController: AccentColorController

    @State var changed = UUID()
    
    var body: some View {
        StyledNavigationBar {
            if let userSetings = context.getUserSettings() {
                List {
                    LanguagePicker(userSetings, label: "Language") { language in
                        userSetings.language = language.rawValue
                        context.saveContext()
                    }
                    
                    EditorThemePicker(userSetings,  label: "Editor Theme") { theme in
                        userSetings.editorTheme = theme.rawValue
                        context.saveContext()
                    }
                    
                    AccentColorPicker(userSetings, label: "Accent color") { accentColor in
                        userSetings.accentColor = accentColor.rawValue
                        context.saveContext()
                        accentColorController.reloadAccentColor()
                    }
                }
                .scrollContentBackground(.hidden)
                
            } else {
                VStack {
                    Text("Could not load settings")
                        .font(.caption)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
    }
}

extension Binding {
    func onChange(_ handle: @escaping (Value) -> Void) -> Binding<Value> {
        return Binding(
            get: { self.wrappedValue },
            set: { selection in
                self.wrappedValue = selection
                handle(selection)
            }
        )
    }
}

struct LanguagePicker: View {
    @EnvironmentObject private var accentColorController: AccentColorController

    @State private var language: Language
    
    let label: String
    let caption: String?
    
    let onChange: (Language) -> Void

    init(_ userSettings: UserSetting, label: String, caption: String? = nil, onChange: @escaping (Language) -> Void) {
        self.language = Language(rawValue: userSettings.language ?? "") ?? .javascript
        self.label = label
        self.caption = caption
        self.onChange = onChange
    }
    
    var body: some View {
        Picker(selection: $language.onChange(onChange)) {
            ForEach(Language.allCases) { option in
                Text(option.rawValue)
            }
        } label: {
            VStack(alignment: .leading) {
                Text(label)
                    .bold()
                if let caption = caption {
                    Text(caption)
                        .font(.caption)
                }
            }
        }
        .pickerStyle(.menu)
        .buttonStyle(.bordered)
        .padding(.vertical, 2)
    }
}

struct EditorThemePicker: View {
    @State private var editorTheme: EditorTheme
    
    let label: String
    let caption: String?
    
    let onChange: (EditorTheme) -> Void
    
    init(_ userSettings: UserSetting, label: String, caption: String? = nil, onChange: @escaping (EditorTheme) -> Void) {
        self.editorTheme = EditorTheme(rawValue: userSettings.editorTheme ?? "") ?? .agate
        self.label = label
        self.caption = caption
        self.onChange = onChange
    }
    
    var body: some View {
        Picker(selection: $editorTheme.onChange(onChange)) {
            ForEach(EditorTheme.allCases) { option in
                Text(option.rawValue)
            }
        } label: {
            VStack(alignment: .leading) {
                Text(label)
                    .bold()
                if let caption = caption {
                    Text(caption)
                        .font(.caption)
                }
            }
        }
        .pickerStyle(.menu)
        .buttonStyle(.bordered)
        .padding(.vertical, 2)
    }
}

struct AccentColorPicker: View {
    @State private var accentColor: AccentColor

    let label: String
    let caption: String?
    
    let onChange: (AccentColor) -> Void

    init(_ userSettings: UserSetting, label: String, caption: String? = nil, onChange: @escaping (AccentColor) -> Void) {
        self.accentColor = AccentColor(rawValue: userSettings.accentColor ?? "") ?? .original
        self.label = label
        self.caption = caption
        self.onChange = onChange
    }
    
    var body: some View {
        Picker(selection: $accentColor.onChange(onChange)) {
            ForEach(AccentColor.allCases) { option in
                Text(option.rawValue)
            }
        } label: {
            VStack(alignment: .leading) {
                Text(label)
                    .bold()
                if let caption = caption {
                    Text(caption)
                        .font(.caption)
                }
            }
        }
        .pickerStyle(.menu)
        .buttonStyle(.bordered)
        .padding(.vertical, 2)
    }
}



struct UserSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        AttachStubEnvironmentObjects {
            UserSettingsView()
        }
    }
}
