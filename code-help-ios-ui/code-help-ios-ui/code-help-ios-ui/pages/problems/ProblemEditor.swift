import SwiftUI
import UserNotifications
import Authentication

struct ProblemEditor: View {
    @EnvironmentObject private var webClient: ClientContainer
    @EnvironmentObject private var authenticationService: AuthenticationService

    @State private var runTask: Task<Void, Never>? = nil;
    @State private var submitTask: Task<Void, Never>? = nil;
    @State private var submissionResult: String? = nil;
    @State private var result: String?
    
    let problem: ProblemDetails
    let markdown: String
    @State var code: String
    let language: Language
    
    init(problem: ProblemDetails, language: Language) {
        self.problem = problem
        self.markdown = problem.markdown ?? ""
        self._code = State(wrappedValue: problem.code)
        self.language = language
    }
    
    private func requestResult(request: () async throws -> String) async -> String {
        do {
            try await UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound])
        } catch {
            print(error)
        }

        do {
            let response = try await request()
            notifyAboutBuild(result: response);
            return response
        } catch {
            print(error)
        }
        
        notifyAboutBuild(result: "Tests faield");
        return "Tests failed"
    }
    
    func run() {
        runTask?.cancel()
        runTask = Task.detached {
            let result = await requestResult {
                try await webClient.codeHelpClient.runCode(forProblem: problem.id, writenIn: language.rawValue, withCode: code)
            }
            await MainActor.run {
                self.result = result
            }
            await runTask?.cancel()
        }
    }
    
    func submit() {
        submitTask?.cancel()
        submitTask = Task.detached {
            let result = await requestResult {
                let response = try await webClient.codeHelpClient.submit(forProblem: problem.id, writenIn: language.rawValue, withCode: code)
                if let contestId = problem.contestId, response.hasPrefix("All") {
                    try await webClient.codeHelpClient.setScore(inContestId: contestId, forProblemId: problem.id)
                }
                return response
            }
            await MainActor.run {
                self.result = result
            }
            await submitTask?.cancel()
        }
    }
    
    func notifyAboutBuild(result: String) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                print("yay")
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
        
        let content = UNMutableNotificationContent()
        content.title = "Code finished running"
        content.subtitle = result
        content.sound = UNNotificationSound.default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
        
    }
    
    var body: some View {
        GeometryReader { g in
            VStack {
                ProblemEditorTabs(markdown: markdown, code: $code, language: language, result: $result)
                .frame(height: result != nil ? g.size.height * 3 / 4: g.size.height)
                if let result = result {
                    VStack {
                        HStack {
                            Text("Result")
                            Spacer()
                            Button {
                                self.result = nil
                            } label: {
                                Image(systemName: "xmark")
                            }
                        }
                        
                        Divider()
                        
                        HStack {
                            Text(result)
                            Spacer()
                        }
                        
                        Spacer()
                    }
                    .padding()
                    .background(.secondaryBackground)
                    .shadow(radius: 10)
                    .frame(height: g.size.height / 4)
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    run()
                } label: {
                    Image(systemName: "play.fill")
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    submit()
                } label: {
                    Image(systemName: "paperplane.fill")
                }
                .disabled(!authenticationService.state.isAuthorized)
            }
        }
    }
}

struct ProblemEditorTabs: View {
    @State private var tabId: Int = 1
    
    let markdown: String
    @Binding var code: String
    let language: Language
    
    @Binding var result: String?
    
    var body: some View {
        NavigationView {
            VStack {
                TabView(selection: $tabId) {
                    MarkdownView(text: markdown).tag(1)
                    Editor(code: $code, language: language).tag(2)
                }
            }
            .frame(maxHeight: .infinity, alignment: .top)
            .tabViewStyle(.page(indexDisplayMode: .never))
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Color.clear, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Grid {
                        GridRow {
                            Button {
                                if (tabId != 1) {
                                    tabId = 1
                                }
                            } label: {
                                Text("Problem")
                                    .frame(maxWidth: .infinity)
                            }
                            .buttonStyle(.tabbed(tabId == 1))
                            .disabled(tabId == 1)
                            
                            HStack {
                                Divider()
                            }
                            
                            Button {
                                if tabId != 2 {
                                    tabId = 2
                                }
                            } label: {
                                Text("Editor")
                                    .frame(maxWidth: .infinity)
                            }
                            .buttonStyle(.tabbed(tabId == 2))
                            .disabled(tabId == 2)
                        }
                    }
                    .ignoresSafeArea()
                }
            }
        }
    }
}

struct ProblemEditor_Previews: PreviewProvider {
    static var previews: some View {
        AttachEnvironmentObjects {
            ProblemEditor(
                problem: .init(
                    id: 0,
                    contestId: nil,
                    name: "Problem",
                    description: nil,
                    dificulty: "Hard",
                    category: nil,
                    likes: "100",
                    markdown: dummyMarkdown,
                    code: "function main() {\n  let name = \"Hello\" \n}"
                ),
                language: Language.javascript
            )
        }
    }
}


let dummyMarkdown = """
# Swift Markdown

Swift `Markdown` is a Swift package for parsing, building, editing, and analyzing Markdown documents.

The parser is powered by GitHub-flavored Markdown's [cmark-gfm](https://github.com/github/cmark-gfm) implementation, so it follows the spec closely. As the needs of the community change, the effective dialect implemented by this library may change.

The markup tree provided by this package is comprised of immutable/persistent, thread-safe, copy-on-write value types that only copy substructure that has changed. Other examples of the main strategy behind this library can be seen in [SwiftSyntax](https://github.com/apple/swift-syntax).

## Getting Started Using Markup

In your `Package.swift` Swift Package Manager manifest, add the following dependency to your `dependencies` argument:

```swift
.package(url: "https://github.com/apple/swift-markdown.git", branch: "main"),
```

Add the dependency to any targets you've declared in your manifest:

```swift
.target(
    name: "MyTarget",
    dependencies: [
        .product(name: "Markdown", package: "swift-markdown"),
    ]
),
```

To parse a document, use `Document(parsing:)`, supplying a `String` or `URL`:

```swift
import Markdown

let source = "This is a markup *document*."
let document = Document(parsing: source)
print(document.debugDescription())
// Document
// └─ Paragraph
//    ├─ Text "This is a markup "
//    ├─ Emphasis
//    │  └─ Text "document"
//    └─ Text "."
```

Please see Swift `Markdown`'s [documentation site](https://apple.github.io/swift-markdown/documentation/markdown/)
for more detailed information about the library.

## Getting Involved

### Submitting a Bug Report

Swift Markdown tracks all bug reports with [GitHub Issues](https://github.com/apple/swift-markdown/issues).
You can use the "Swift-Markdown" component for issues and feature requests specific to Swift Markdown.
When you submit a bug report we ask that you follow the
Swift [Bug Reporting](https://swift.org/contributing/#reporting-bugs) guidelines
and provide as many details as possible.

### Submitting a Feature Request

For feature requests, please feel free to file a [GitHub issue](https://github.com/apple/swift-markdown/issues/new)
or start a discussion on the [Swift Forums](https://forums.swift.org/c/development/swift-docc).

Don't hesitate to submit a feature request if you see a way
Swift Markdown can be improved to better meet your needs.

### Contributing to Swift Markdown

Please see the [contributing guide](https://swift.org/contributing/#contributing-code) for more information.

<!-- Copyright (c) 2021-2023 Apple Inc and the Swift Project authors. All Rights Reserved. -->
"""
