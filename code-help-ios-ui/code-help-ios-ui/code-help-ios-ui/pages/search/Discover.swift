//
//  Discover.swift
//  code-help-ios-ui
//
//  Created by Vangel Trajkovski on 5.8.23.
//

import SwiftUI

enum CriteriaType {
    case search
    case filter
    case sort
}

struct Criteria: Identifiable {
    let id = UUID()
    let name: String
    let value: String
    let type: CriteriaType
}

struct Discover<Content :View, Data>: View {
    typealias ContentFetch = ([Criteria]) async -> Data
    
    @State private var showingSheet = false
    @State private var selected = TilingOption.list
    @State private var searchable = true
    @State private var searchText = ""
    @State private var criterias: [Criteria] = []
    @State private var data: Data? = nil
    
    let sortCriteria: [CriteriaPropertyOption]

    @ViewBuilder var content: (Data?, TilingOption) -> Content
    let suplier: ContentFetch?
    
    private func suply(with criteria: [Criteria]) {
        Task(priority: .background) {
            let response = await suplier?(criteria)
            await MainActor.run {
                data = response
            }
        }
    }
    
    private func getCriterias(ofType type: CriteriaType) -> (() -> [String]) {
        return {
            criterias
                .filter { criteria in criteria.type == type }
                .map { criteria in criteria.name }
        }
    }
    
    var body: some View {
        StyledNavigationBar {
            VStack {
                TopActions {
                    SortSelectButton(options: sortCriteria, excluded: getCriterias(ofType: .sort)) { items in
                        let newCriterias = items.map { item in
                            Criteria(name: item.name, value: item.selectedOption.rawValue, type: .sort)
                        }
                        criterias.append(contentsOf: newCriterias)
                        suply(with: criterias)
                    }
                    .buttonStyle(.invertedBordered)
                    TilingSelector(selected: $selected)
                }
                .padding(criterias.isEmpty ? .top : .vertical)
                
                if !criterias.isEmpty {
                    Flex {
                        ForEach(Array(criterias.enumerated()), id: \.element.id) { index, criteria in
                            Button {
                                criterias.remove(at: index)
                            } label: {
                                HStack(spacing: 10) {
                                    Text("\(criteria.name): \(criteria.value)")
                                    Image(systemName: "xmark")
                                }
                            }
                            .buttonStyle(.lightBordered)
                        }
                    }
                    .padding()
                    .background(.secondaryBackground)
                    .cornerRadius(20)
                    .padding(.horizontal)
                }
                
                VStack(alignment: .center) {
                    content(data, selected)
                }
                .frame(maxHeight: .infinity)
            }
            .toolbar(.hidden, for: .tabBar)
            SearchBarView(searchText: $searchText, show: $searchable) {
                criterias.append(Criteria(name: "search", value: searchText, type: .search))
                suply(with: criterias)
            }
        }
        .task(priority: .background) {
            suply(with: criterias)
        }
    }
}

struct SortSelectButton: View {
    @State private var showingSheet = false
    
    let options: [CriteriaPropertyOption]
    var excluded: (() -> [String])?
    var selectOptions: (([SortingProp]) -> Void)?
    
    var body: some View {
        Button {
            showingSheet.toggle()
        } label: {
            HStack {
                Image(systemName: "list.bullet.circle.fill")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .aspectRatio(1, contentMode: .fit)
                    .scaledToFit()
                    .foregroundColor(.primary)
                Text("Sort")
            }
            .frame(maxWidth: .infinity)
        }
        .sheet(isPresented: $showingSheet) {
            SortSelect(exclude: excluded?() ?? [], propertyOptions: options) { selectedOptions in
                selectOptions?(selectedOptions)
            }
        }
    }
}

private struct DiscoverData: Identifiable {
    let id = UUID()
    let image = "csharp"
    let title = "Some Problem"
    let subtitle = "easy"
}

struct Discover_Previews: PreviewProvider {
    static var previews: some View {
        let sortCriteria: [CriteriaPropertyOption] = [
            CriteriaPropertyOption(id: "name", label: "Name: "),
            CriteriaPropertyOption(id: "id", label: "Id: "),
            CriteriaPropertyOption(id: "problem", label: "Problem: ")
        ]
        
        NavigationStack {
            Discover(sortCriteria: sortCriteria) { t, _ in
                if let t = t {
                    List {
                        ForEach(t) { t in
                            NavigationLink {
                                
                            } label: {
                                HStack(spacing: 20) {
                                    Image(t.image)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: 40)
                                    
                                    VStack(alignment: .leading) {
                                        Text(t.title)
                                        Text(t.subtitle)
                                    }
                                }
                            }
                        }
                    }
                }
                
            } suplier: { c in
                [
                    DiscoverData(),
                    DiscoverData(),
                    DiscoverData(),
                    DiscoverData(),
                    DiscoverData(),
                    DiscoverData(),
                    DiscoverData()
                ]
            }
        }
    }
}
