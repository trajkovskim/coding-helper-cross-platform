//
//  CommunityDiscover.swift
//  code-help-ios-ui
//
//  Created by Martin Trajkovski on 31.8.23.
//

import SwiftUI
import ForumApi
import Authentication

struct CommunityDiscoverTile: Identifiable {
    let id = UUID()
    let image: String?
    let name: String
    let tags: [String]
}


struct CommunityDiscover: View {
    @EnvironmentObject private var authenticationService: AuthenticationService
    @EnvironmentObject private var webClient: ClientContainer
    
    func fetchData(_ criteria: [Criteria]) async -> [Components.Schemas.ShortCommunity] {
        return await webClient.forumClient.getAllCommunities().sorted { lc, rc in
            if !criteria.isEmpty {
                return lc.name < rc.name
            }
            
            return true
        }
    }
    
    var body: some View {
        Discover(sortCriteria: [ .init(id: "name", label: "Name") ], filterCriteria: []) { items, tile in
            if let items = items, items.count > 0 {
                switch tile {
                    case .list:
                        CommunityDiscoverList(communities: items)
                    case .grid:
                        CommunityDiscoverGrid(communities: items)
                }
            } else {
                TimeoutFallback(timeout: 10) {
                    ProgressView()
                        .progressViewStyle(.circular)
                } fallback: {
                    Text("No data")
                }
            }
        } suplier: { criteria in
            await fetchData(criteria)
        }
    }
}

struct CommunityDiscoverList: View {
    let communities: [Components.Schemas.ShortCommunity]
    
    var body: some View {
        List {
            ForEach(communities, id: \.name) { community in
                NavigationLink {
                    CommunityView(communityName: community.name)
                } label: {
                    CommunityDiscoverListTile(community: community.toDiscoverTileItem())
                }
            }
            .scrollContentBackground(.hidden)
        }
    }
}

struct CommunityDiscoverGrid: View {
    let communities: [Components.Schemas.ShortCommunity]
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns) {
                ForEach(communities, id: \.name) { community in
                    NavigationLink {
                        CommunityView(communityName: community.name)
                    } label: {
                        CommunityDiscoverGridTile(community: community.toDiscoverTileItem())
                    }
                }
            }
        }
        .padding()
    }
}


struct CommunityDiscoverListTile: View {
    let community: CommunityDiscoverTile

    var body: some View {
        HStack(spacing: 20) {
            if let image = community.image {
                Image(image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
            } else {
                Image(systemName: "person.3.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
            }
            
            VStack(alignment: .leading) {
                Text(community.name)
                HStack {
                    Text("Tags:")
                        .bold()
                        .font(.caption)
                    if  community.tags.count > 0 {
                        ForEach(community.tags, id: \.self) { itemTag in
                            Button {
                            } label: {
                                Text(itemTag)
                            }
                            .disabled(true)
                            .buttonStyle(.lightBordered)
                            .font(.caption)
                        }
                        
                    } else {
                        Text("none")
                            .bold()
                            .font(.caption)
                    }
                }
            }
        }
    }
}

struct CommunityDiscoverGridTile: View {
    let community: CommunityDiscoverTile
    var body: some View {
        VStack {
            if let image = community.image {
                Image(image)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 68)
            } else {
                Image(systemName: "person.3.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 68)
            }
            
            Divider()
            
            Spacer(minLength: 10)
            
            Text(community.name)
            
            Spacer(minLength: 20)
            
            HStack {
                Text("Tags:")
                    .bold()
                    .font(.caption)
                if  community.tags.count > 0 {
                    ForEach(community.tags, id: \.self) { itemTag in
                        Button {
                        } label: {
                            Text(itemTag)
                        }
                        .disabled(true)
                        .buttonStyle(.lightBordered)
                        .font(.caption)
                    }
                    
                } else {
                    Text("none")
                        .bold()
                        .font(.caption)
                }
                
                Spacer()
            }
        }
        .multilineTextAlignment(.leading)
        .foregroundColor(.primary)
        .padding()
        .frame(maxWidth: .infinity)
        .background(.secondaryBackground)
        .cornerRadius(16)
    }
}

struct CommunityDiscover_Previews: PreviewProvider {
    static var previews: some View {
        AttachEnvironmentObjects {
            NavigationStack {
                CommunityDiscover()
            }
        }
    }
}
