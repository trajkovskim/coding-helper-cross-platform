//
//  SearchBar.swift
//  code-help-ios-ui
//
//  Created by Vangel Trajkovski on 12.8.23.
//

import SwiftUI


struct SearchBarView: View {
    @Binding var searchText: String
    @Binding var show: Bool
    @StateObject var model = SearchHandlerModel()
    
    var done: (() -> Void)?
    
    var body: some View {
        if show {
            HStack {
                SearchHandler(model)
                    .frame(width: 0, height: 0)
                    .searchable(text: $searchText, placement: .toolbar)
                    .onSubmit(of: .search) {
                        model.dismissSearch()
                        done?()
                    }
            }
        } else {
            HStack {}
                .frame(width: 0, height: 0)
        }
    }
}

class SearchHandlerModel: ObservableObject {
    var closeSearch = false
    
    func dismissSearch() {
        closeSearch.toggle()
        self.objectWillChange.send()
    }
}

struct SearchHandler: View {
    @Environment(\.dismissSearch) private var closeSearch
    @ObservedObject var model: SearchHandlerModel
    
    init(_ model: SearchHandlerModel) {
        self.model = model
    }
    
    var body: some View {
        HStack {
        }
        .frame(width: 0, height: 0)
        .onChange(of: model.closeSearch) { _ in
            closeSearch()
        }
    }
}


struct SearchBar_Previews: PreviewProvider {
    static var previews: some View {
        @State var searchText = ""
        @State var show = true
        NavigationView {
            SearchBarView(searchText: $searchText, show: $show)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            
                        } label: {
                            Image(systemName: "magnifyingglass")
                        }
                    }
                }
        }
    }
}
