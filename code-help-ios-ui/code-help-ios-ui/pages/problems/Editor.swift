import SwiftUI
import CodeEditor

struct Editor: View {
    @Environment(\.managedObjectContext) var context
    @Binding var code: String
    var language: Language
    let editable: Bool
    
    var editorTheme: CodeEditor.ThemeName {
        context.getUserSettings()?.editorTheme?.toEditorTheme()?.toEditorThemeName() ?? .agate
    }
    
    init(code: Binding<String>, language: Language) {
        self._code = code
        self.language = language
        self.editable = true
    }
    
    init(code: String, language: Language) {
        self._code = Binding {
            code
        } set: { _ in }
        self.language = language
        self.editable = false
    }
    
    func extractLanguage(from value: Language) -> CodeEditor.Language {
        return CodeEditor.Language(rawValue: value.rawValue)
    }
    
    var body: some View {
        StyledNavigationBar {
            if editable {
                CodeEditor(source: $code, language: extractLanguage(from: language), theme: editorTheme)
                    .toolbar(.hidden, for: .tabBar)
            } else {
                CodeEditor(source: $code, language: extractLanguage(from: language), theme: editorTheme, flags: .selectable)
                    .toolbar(.hidden, for: .tabBar)
            }
        }
    }
}

struct Editor_Previews: PreviewProvider {
    static var previews: some View {
        @State var code = "function main() {\n  let name = \"Hello\" \n}"
        AttachStubEnvironmentObjects {
            Editor(code: $code, language: Language.javascript)
        }
    }
}
