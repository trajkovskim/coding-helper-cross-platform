import SwiftUI
import MarkdownUI

struct MarkdownView: View {
    let text: String
    
    var body: some View {
        StyledNavigationBar {
            ScrollView {
                Markdown(text)
                    .markdownTheme(.gitHub)
                    .markdownMargin(top: 80, bottom: 80)
                    .background(.secondaryBackground)
                    .padding()
                    .background(.secondaryBackground)
            }
            .toolbar(.hidden, for: .tabBar)
        }
    }
}

struct MarkdownView_Previews: PreviewProvider {
    static var previews: some View {
        MarkdownView(text: dummyMarkdown)
    }
}


