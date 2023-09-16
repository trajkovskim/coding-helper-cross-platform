//
//  RequestDataFallback.swift
//  code-help-ios-ui
//
//  Created by Vangel Trajkovski on 2.9.23.
//

import SwiftUI

class RequestState: ObservableObject {
    @Published var state: State = .loading
    
    func wrap<T>(request: @escaping () async throws -> T) async -> T? {
        do {
            await MainActor.run {
                state = .loading
            }
            
            let response = try await request()
            await MainActor.run {
                state = .done
            }
            
            return response
        }
        catch {
            print(error)
            await MainActor.run {
                state = .failed
            }
        }
        
        return nil
    }
    
    enum State {
        case loading
        case done
        case failed
    }
}


struct RequestDataFallback<Data, LoadingView: View, Content: View, ErrorView: View, TimeoutView: View>: View {
    typealias LoadingViewBuilder = () -> LoadingView
    typealias ErrorViewBuilder = () -> LoadingView
    typealias TimeoutViewBuilder = () -> TimeoutView
    typealias ContentView = (Data, @escaping RefreshTrigger) -> Content
    typealias RefreshTrigger = () -> Void
    typealias Suplier = () async throws -> Data
    
    @EnvironmentObject var webClient: ClientContainer
    @ObservedObject var requestState = RequestState()
    
    @State private var refreshTask: Task<Void, Never>? = nil
    @State var data: Data? = nil
    
    @ViewBuilder var content: ContentView
    private let loading: LoadingViewBuilder?
    private let error: ErrorViewBuilder?
    private let timeout: TimeoutViewBuilder?
    
    let suplier: Suplier
    
    private init(_ content: @escaping ContentView, _ loading: LoadingViewBuilder?, _ error: ErrorViewBuilder?, _ timeout: TimeoutViewBuilder?, _ suplier: @escaping Suplier) {
        self.content = content
        self.loading = loading
        self.error = error
        self.suplier = suplier
        self.timeout = timeout
    }
    
    init(content: @escaping ContentView, suplier: @escaping Suplier) where ErrorView == EmptyView, LoadingView == EmptyView, TimeoutView == LoadingView {
        self.init(content, nil, nil, nil, suplier)
    }
    
    init(content: @escaping ContentView, loading: @escaping LoadingViewBuilder, suplier: @escaping Suplier) where ErrorView == EmptyView, TimeoutView == LoadingView {
        self.init(content, loading, nil, nil, suplier)
    }
    
    
    init(content: @escaping ContentView, timeout: @escaping TimeoutViewBuilder, suplier: @escaping Suplier) where ErrorView == EmptyView, TimeoutView == LoadingView  {
        self.init(content, nil, nil, timeout, suplier)
    }
    
    init(content: @escaping ContentView, @ViewBuilder error: @escaping ErrorViewBuilder, suplier: @escaping Suplier) {
        self.init(content, nil, error, nil, suplier)
    }
    
    
    init(content: @escaping ContentView, @ViewBuilder timeout: @escaping TimeoutViewBuilder, @ViewBuilder error: @escaping ErrorViewBuilder , suplier: @escaping Suplier) where LoadingView == EmptyView  {
        self.init(content, nil, error, timeout, suplier)
    }
    
    init(content: @escaping ContentView, @ViewBuilder loading: @escaping LoadingViewBuilder, @ViewBuilder error: @escaping ErrorViewBuilder, suplier: @escaping Suplier) where TimeoutView == EmptyView {
        self.init( content, loading, error, nil, suplier)
    }
    
    
    private func suply() async {
        let response  = await requestState.wrap {
            return try await suplier()
        }
        
        await MainActor.run {
            data = response
        }
    }
    
    private func refresh() {
        refreshTask?.cancel()
        refreshTask = Task.detached {
            await suply()
            await MainActor.run {
                refreshTask?.cancel()
            }
        }
    }
    
    var body: some View {
        VStack {
            switch (requestState.state) {
                case .loading:
                    if let loading = loading {
                        loading()
                    } else {
                        TimeoutFallback(timeout: 5) {
                            ProgressView()
                                .progressViewStyle(.circular)
                        } fallback: {
                            if let timeout = timeout {
                                timeout()
                            } else {
                                Text("Took too long.").font(.caption)
                            }
                        }
                    }
                case .done:
                    if let data = data {
                        content(data, refresh)
                    } else {
                        if let error = error {
                            error()
                        } else {
                            Text("Failed to fetch data").font(.caption)
                        }
                    }
                case .failed:
                    if let error = error {
                        error()
                    } else {
                        Text("Failed to fetch data").font(.caption)
                    }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .task(priority: .background) {
            await suply()
        }
        .onDisappear {
            refreshTask?.cancel()
            refreshTask = nil
        }
    }
}


struct RequestDataFallback_Previews: PreviewProvider {
    static var previews: some View {
        AttachEnvironmentObjects {
            ForumView()
        }
    }
}
