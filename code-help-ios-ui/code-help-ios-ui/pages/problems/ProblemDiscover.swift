//
//  ProblemDiscover.swift
//  code-help-ios-ui
//
//  Created by Vangel Trajkovski on 3.9.23.
//

import SwiftUI
import CodeHelpApi


struct ProblemDiscover: View {
    @EnvironmentObject private var webClient: ClientContainer

    let filterCriteria: [any FilterOptionProtocol] = [
        LanguageFilter(name: "language", label: "Language:", selected: .Java),
        DificultyFilter(name: "dificulty", label: "Dificulty:", selected: .Easy)
    ]
    let sortCriteria: [CriteriaPropertyOption] = [
        CriteriaPropertyOption(id: "name", label: "Name: "),
        CriteriaPropertyOption(id: "id", label: "Id: "),
        CriteriaPropertyOption(id: "problem", label: "Problem: ")
    ]
    
    func fetchData() async -> [Components.Schemas.ProblemEntry] {
        do {
            return try await webClient.codeHelpClient.getProblems()
        } catch {
            print(error)
            return []
        }
    }
    
    var body: some View {
        Discover(sortCriteria: sortCriteria, filterCriteria: filterCriteria) { problems, tiling in
            if let problems = problems {
                switch tiling {
                    case .list:
                        ProblemDiscoverList(problems: problems)
                    case .grid:
                        ProblemDiscoverGrid(problems: problems)
                }
            }
        } suplier: { c in
            await fetchData()
        }
    }
}

struct ProblemDiscoverList: View {
    let problems: [Components.Schemas.ProblemEntry]
    
    var body: some View {
        List {
            ForEach(problems, id: \.value2.id) { problem in
                ProblemDiscoverListItemLink(problem: problem.toDiscoverData())
            }
        }
    }
}

struct ProblemDiscoverListItemLink: View {
    let problem: ProblemDiscoverData
    
    var body: some View {
        NavigationLink {
            ProblemDetailsView(problemId: problem.id)
        } label: {
            ProblemDiscoverListItem(problem: problem)
        }
    }
}


struct ProblemDiscoverListItem: View {
    let problem: ProblemDiscoverData
    
    var body: some View {
        HStack(spacing: 20) {
            Image(problem.image ?? LanguageIcon.randomIcon())
                .resizable()
                .scaledToFit()
                .frame(height: 40)
                .frame(maxWidth: 40)
            
            VStack(alignment: .leading) {
                Text(problem.title)
                Text(problem.subtitle)
            }
        }
    }
}

struct ProblemDiscoverGrid: View {
    let problems: [Components.Schemas.ProblemEntry]

    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns) {
                ForEach(problems, id: \.value2.id) { problem in
                    ProblemDiscoverGridItemLink(problem: problem.toDiscoverData())
                }
            }
            .padding()
        }
    }
}

struct ProblemDiscoverGridItemLink: View {
    let problem: ProblemDiscoverData
    
    var body: some View {
        NavigationLink {
            ProblemDetailsView(problemId: problem.id)
        } label: {
            ProblemDiscoverGridItem(problem: problem)
        }
    }
}


struct ProblemDiscoverGridItem: View {
    let problem: ProblemDiscoverData
    
    var body: some View {
        VStack {
            Image(problem.image ?? LanguageIcon.randomIcon())
                .resizable()
                .scaledToFit()
                .frame(height: 68)
            
            Divider()
            
            Spacer(minLength: 10)
            
            Text(problem.title)
            
            Spacer(minLength: 20)
            
            Text(problem.subtitle)
        }
        .multilineTextAlignment(.leading)
        .foregroundColor(.primary)
        .padding()
        .frame(maxWidth: .infinity)
        .background(.secondaryBackground)
        .cornerRadius(16)
    }
}

struct ProblemDiscover_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            AttachEnvironmentObjects {
                ProblemDiscover()
            }
        }
    }
}
