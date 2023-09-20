//
//  ContestDiscover.swift
//  code-help-ios-ui
//
//  Created by Vangel Trajkovski on 6.9.23.
//

import SwiftUI
import CodeHelpApi

struct ContestDiscoverData {
    let id: Int
    let image: String
    let title: String
    let subtitle: String
    let duration: String
}


struct ContestDiscover: View {
    @EnvironmentObject private var webClient: ClientContainer

    let filterCriteria: [any FilterOptionProtocol] = [
        LanguageFilter(name: "language", label: "Language:", selected: .Java),
        DificultyFilter(name: "dificulty", label: "Dificulty:", selected: .Easy)
    ]
    let sortCriteria: [CriteriaPropertyOption] = [
        CriteriaPropertyOption(id: "name", label: "Name: "),
        CriteriaPropertyOption(id: "id", label: "Id: "),
        CriteriaPropertyOption(id: "Contest", label: "Contest: ")
    ]
    
    func fetchData(with criteria: [Criteria]) async -> [Components.Schemas.ContestEntry] {
        do {
            return try await webClient.codeHelpClient.getContests()
        } catch {
            print(error)
            return []
        }
    }
    
    var body: some View {
        Discover(sortCriteria: sortCriteria, filterCriteria: filterCriteria) { contests, tile in
            if let contests = contests {
                switch tile {
                    case .list:
                        ContestDiscoverList(contests: contests)
                    case .grid:
                        ContestDiscoverGrid(contests: contests)
                }
            }
        } suplier: { criteria in
            await fetchData(with: criteria)
        }
    }
}


struct ContestDiscoverList: View {
    let contests: [Components.Schemas.ContestEntry]
    
    var body: some View {
        List {
            ForEach(contests, id: \.value2.id) { Contest in
                ContestDiscoverListItemLink(Contest: Contest.toDiscoverData())
            }
        }
    }
}

struct ContestDiscoverListItemLink: View {
    let Contest: ContestDiscoverData
    
    var body: some View {
        NavigationLink {
            ContestDetailsView(contestId: Contest.id)
        } label: {
            ContestDiscoverListItem(contest: Contest)
        }
    }
}


struct ContestDiscoverListItem: View {
    let contest: ContestDiscoverData
    
    var body: some View {
        HStack(spacing: 20) {
            Image(contest.image)
                .resizable()
                .scaledToFit()
                .frame(height: 40)
                .frame(maxWidth: 40)
            
            VStack(alignment: .leading) {
                Text(contest.title)
                Text(contest.subtitle)
            }
        }
    }
}

struct ContestDiscoverGrid: View {
    let contests: [Components.Schemas.ContestEntry]
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns) {
                ForEach(contests, id: \.value2.id) { contest in
                    ContestDiscoverGridItemLink(contest: contest.toDiscoverData())
                }
            }
            .padding()
        }
    }
}

struct ContestDiscoverGridItemLink: View {
    let contest: ContestDiscoverData
    
    var body: some View {
        NavigationLink {
            ContestDetailsView(contestId: contest.id)
        } label: {
            ContestDiscoverGridItem(contest: contest)
        }
    }
}


struct ContestDiscoverGridItem: View {
    let contest: ContestDiscoverData
    
    var body: some View {
        VStack {
            Image(contest.image)
                .resizable()
                .scaledToFit()
                .frame(height: 68)
            
            Divider()
            
            Spacer(minLength: 10)
            
            Text(contest.title)
            
            Spacer(minLength: 20)
            
            Text(contest.subtitle)
        }
        .multilineTextAlignment(.leading)
        .foregroundColor(.primary)
        .padding()
        .frame(maxWidth: .infinity)
        .background(.secondaryBackground)
        .cornerRadius(16)
    }
}

struct ContestDiscover_Previews: PreviewProvider {
    static var previews: some View {
        AttachEnvironmentObjects {
            NavigationStack {
                ContestDiscover()
            }
        }
    }
}
