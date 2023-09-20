import SwiftUI
import CodeHelpApi
import CoreData
import Authentication

extension ProblemDetails {
    func toHistoryDto() -> HistoryProblemDto {
        .init(id: self.id, name: self.name, contestId: self.contestId)
    }
}

struct ProblemDetailsView: View {
    @EnvironmentObject private var webClient: ClientContainer

    private let sectionSpacing: Double = 40
    private let cornerRadius: Double = 10.0
    var problemId: Int
    var contestId: Int? = nil
    var shouldSave = true
    
    var body: some View {
        StyledNavigationBar(title: "Problem") {
                VStack {
                    RequestDataFallback { problem, refresh in
                        ProblemDetailsInfo(
                            problem: problem.toProblemDetailsModel(contestId: contestId),
                            sectionSpacing: sectionSpacing,
                            cornerRadius: cornerRadius,
                            shouldSave: shouldSave,
                            refresh: refresh
                        )
                    } suplier: {
                        try await webClient.codeHelpClient.getProblem(id: problemId)
                    }
                }
                .padding(.vertical)
                .background(.primaryBackground)
        }
    }
}

struct ProblemDetailsInfo: View {
    @Environment(\.managedObjectContext) private var context

    let problem: ProblemDetails
    var sectionSpacing = 40.0
    var cornerRadius = 10.0
    var shouldSave = true
    let refresh: () -> Void
    
    var body: some View {
        ProblemInfo(problem: problem, cornerRadius: cornerRadius, refresh: refresh, context: context)
            .onAppear {
                if shouldSave {
                    let dto = problem.toHistoryDto()
                    let _ = HistoryProblem(dto: dto, context: context)
                    do {
                        try context.save()
                    } catch {
                        print(error)
                    }
                }
            }
        if let description = problem.description {
            Spacer(minLength: sectionSpacing)
            ProblemDescription(description: description, cornerRadius: cornerRadius)
        }
        VStack {
            ProblemSumbmissionsRequest(problemId: problem.id)
        }
    }
}

struct ProblemSumbmissionsRequest: View {
    @EnvironmentObject private var webClient: ClientContainer

    let problemId: Int

    var body: some View {
        RequestDataFallback { submissions, refresh in
            ProblemAtemptsView(submissions: submissions) {
                refresh()
            }
        } suplier: {
            sleep(1)
            return try await webClient.codeHelpClient.getSubmissions(forProblemId: problemId)
        }
    }
}

struct ProblemInfo: View {
    @EnvironmentObject private var webClient: ClientContainer
    @EnvironmentObject var authenticationService: AuthenticationService

    @State private var submitButton = false
    @State private var selected: Language
    @State private var isLiked: Bool?
    @State private var likeCheckTask: Task<Void, Never>? = nil
    @State private var likeTask: Task<Void, Never>? = nil
    
    let problem: ProblemDetails
    let refresh: () -> Void

    var cornerRadius = 10.0
    
    init(problem: ProblemDetails, cornerRadius: Double = 10.0, refresh: @escaping () -> Void, context: NSManagedObjectContext) {
        self.problem = problem
        self.cornerRadius = cornerRadius
        self.refresh = refresh
        self.selected = context.getUserSettings()?.language?.toLanguage() ?? Language.javascript
    }
    
    private func checkLike() {
        likeCheckTask?.cancel()
        if authenticationService.state.isAuthorized() && problem.contestId == nil {
            likeCheckTask = Task.detached {
                do {
                    let result = try await webClient.codeHelpClient.isLiked(problem: problem.id)
                    await MainActor.run {
                        self.isLiked = result
                        likeCheckTask?.cancel()
                    }
                } catch {
                    print(error)
                }
                await MainActor.run {
                    likeCheckTask?.cancel()
                }
            }
        }
    }
    
    func like() {
        likeTask?.cancel()
        if authenticationService.state.isAuthorized() && problem.contestId == nil {
            likeTask = Task.detached {
                do {
                    let _ = try await webClient.codeHelpClient.like(problem: problem.id)
                    await MainActor.run {
                        self.isLiked?.toggle()
                        self.refresh()
                    }
                } catch {
                    print(error)
                }
                await MainActor.run {
                    likeTask?.cancel()
                }
            }
        }
    }
    
    var body: some View {
        HStack {
            VStack {
                HStack {
                    Image(LanguageIcon.randomIcon())
                        .resizable()
                        .scaledToFit()
                        .padding(20)
                        .frame(maxWidth: 120, maxHeight: 120)
                    Spacer()
                    VStack {
                        VStack {
                            Text("Dificulty: \(problem.dificulty)")
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Text("Category: \(problem.category ?? "none")")
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Text("Likes: \(problem.likes)")
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .frame(width: 150)
                        .padding(.trailing, 2)
                    }
                }
                Spacer().frame(height: 20)
                HStack {
                    Text(problem.name)
                        .font(Font.system(size: 18))
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                }.padding(.horizontal)
                Spacer().frame(height: 20)
                HStack {
                    Picker(selection: $selected) {
                        ForEach(Language.allCases) { option in
                            Text(option.rawValue)
                        }
                    } label: { }
                    .pickerStyle(.menu)
                    .buttonStyle(.bordered)
                    Spacer()
                    
                    if problem.contestId == nil {
                        Button {
                            like()
                        } label: {
                            Image(systemName: "heart\(isLiked ?? false ? ".fill" : "")")
                        }
                        .disabled(isLiked == nil)
                    }
                    
                    NavigationLink("Start") {
                        ProblemEditor(problem: problem, language: selected)
                    }.buttonStyle(.borderedProminent)
                    
                }.padding(.horizontal)
            }
        }
        .padding(.bottom)
        .background(.secondaryBackground)
        .cornerRadius(cornerRadius)
        .onAppear {
            checkLike()
        }
        .onDisappear {
            likeCheckTask?.cancel()
            likeTask?.cancel()
        }
        .padding(.horizontal)
       
        
    }
}

struct ProblemDescription: View {
    var description: String
    var cornerRadius = 10.0
    
    var body: some View {
        HStack {
            VStack {
                Text("Description: ")
                    .font(Font.system(size: 17))
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text(description)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .frame(minHeight: 100, alignment: .top)
        .padding(.all)
        .background(.secondaryBackground)
        .cornerRadius(cornerRadius)
        .padding(.horizontal)
        
    }
}


struct ProblemAtemptsView: View {
    var submissions: [Components.Schemas.SubmissionEntry]
    let refresh: () -> Void
    
    var body: some View {
        if submissions.count > 0 {
            List {
                ForEach(submissions, id: \.value2.id) { submission in
                    ProblemAtemptRow(atempt: submission.toAtempt())
                }
            }
            .scrollContentBackground(.hidden)
            .refreshable {
                refresh()
            }
        } else {
            ScrollView {
                EmptyStatusView(description: "No attempts")
            }
            .refreshable { refresh() }
            Spacer()
        }
    }
}

struct ProblemAtemptRow: View {
    let atempt: ProblemAtempt
    
    var body: some View {
        HStack {
            NavigationLink {
                Editor(code: atempt.code, language: atempt.language)
            } label: {
                Text(atempt.time.description)
            }
        }
    }
}


struct ProblemDetails_Previews: PreviewProvider {
    static var previews: some View {
        AttachStubEnvironmentObjects {
            NavigationView {
                ProblemDetailsView(problemId: 9)
            }
        }
    }
}
