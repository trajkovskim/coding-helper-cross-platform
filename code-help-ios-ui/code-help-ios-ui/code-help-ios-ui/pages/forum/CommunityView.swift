//
//  CommunityView.swift
//  code-help-ios-ui
//
//  Created by Martin Trajkovski on 1.9.23.
//

import SwiftUI
import ForumApi
import Authentication

private let tags = [ "tag1", "tag2" ]

extension PostDialogData {
    
    func toPostRequest() -> Components.Schemas.PostRequest {
        .init(title: self.title, content: self.content)
    }
}

struct CommunityView: View {
    typealias RefreshTrigger = () -> Void

    @EnvironmentObject private var authenticationService: AuthenticationService
    @EnvironmentObject private var webClient: ClientContainer

    @State var refreshPosts: RefreshTrigger? = nil
    @State var refreshCommunity: RefreshTrigger? = nil
    
    @State private var show: Bool = false
    @State private var dialogType: PostDialogType = .new
    
    @State var createPostTask: Task<Void, Never>? = nil
    
    let communityName: String
    
    func createPost(_ community: String, _ data: PostDialogData) {
        createPostTask?.cancel()
        createPostTask = Task.detached(priority: .background) {
            do {
                let _ = try await webClient.forumClient.createPost(in: community, from: data.toPostRequest())
                await MainActor.run {
                    postRequested()
                }
            } catch {
                print(error)
            }
        }
    }
    
    private func postRequested() {
        refreshPosts?()
        createPostTask?.cancel()
        createPostTask = nil
    }
    
    var body: some View {
        StyledNavigationBar {
            ScrollView {
                CommunityCard(communityName: communityName) { refresh in
                    refreshCommunity = refresh
                }
                ForumPosts(communityName: communityName) { refresh in
                    refreshPosts = refresh
                }
            }
            .refreshable {
                refreshCommunity?()
                refreshPosts?()
                createPostTask?.cancel()
                createPostTask = nil
            }
        }
        .overlay {
            PostModalDialog(
                show: $show,
                dialogType: dialogType,
                communityName: communityName
            ) { community, data in
                createPost(community, data)
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    show.toggle()
                } label: {
                    Image(systemName: "plus")
                }
                .disabled(!authenticationService.state.isAuthorized)
            }
        }
        .onDisappear {
            createPostTask?.cancel()
        }
    }
}

struct CommunityCard: View {
    typealias RefreshAction = () -> Void
    typealias AppearAction = (@escaping RefreshAction) -> Void
    @EnvironmentObject private var webClient: ClientContainer

    let communityName: String
    let appeared: AppearAction?
    
    init(communityName: String, appeared: AppearAction?) {
        self.communityName = communityName
        self.appeared = appeared
    }
    
    var body: some View {
        VStack {
            RequestDataFallback { community, refresh in
                CommunityCardInner(community: community.toCommunityCardModel())
                    .onAppear {
                        appeared?(refresh)
                    }
            } suplier: {
                try await webClient.forumClient.getCommunity(for: communityName)
            }
        }
        .frame(minHeight: 350, maxHeight: 640)
        .background(.secondaryBackground)
        .cornerRadius(10)
        .padding()
    }
}

struct CommunityCardModel {
    let name: String
    let description: String
    let joined: Bool
    let tags: [String]
    let banner: String?
    let image: String?
}

extension Components.Schemas.Community {
    func toCommunityCardModel() -> CommunityCardModel {
        return .init(
            name: self.value1.name,
            description: self.value1.description,
            joined: self.value2.joined,
            tags: self.value1.categories?.map {tag in tag.name} ?? [],
            banner: nil,
            image: nil
        )
    }
}

struct CommunityCardInner: View {
    @EnvironmentObject private var webClient: ClientContainer
    
    let community: CommunityCardModel
    
    var body: some View {
        VStack {
            ZStack(alignment: .center) {
                GeometryReader { g in
                    VStack {
                        VStack(alignment: .center) {
                            Image(community.banner ?? "")
                                .resizable()
                                .scaledToFit()
                        }
                        .frame(maxWidth: .infinity, maxHeight: g.size.height / 2)
                        .background(Color(uiColor: .systemGray4))
                    }
                    VStack {
                        HStack(alignment: .bottom) {
                            if let image = community.image {
                                Image(image)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: g.size.height / 3, height: g.size.height / 3)
                                    .cornerRadius(10)
                            } else {
                                Image(systemName: "person.3.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: g.size.height / 3, height: g.size.height / 3)
                                    .background(.white)
                                    .cornerRadius(.infinity)
                                    .shadow(radius: 10)
                            }
                            CommunityJoinButton(community.joined, for: community.name)
                        }
                        .padding()
                    }
                    .frame(maxHeight: .infinity)
                    VStack {
                        Spacer()
                        HStack(alignment: .bottom) {
                            VStack(alignment: .leading) {
                                Text(community.name)
                                    .font(.title2)
                                    .bold()
                                Text(community.description)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top, ((g.size.height / 3) / 2) + 10)
                        .frame(maxHeight: g.size.height / 2)
                    }
                    .frame(maxHeight: .infinity)
                }
            }
            .frame(maxHeight: 350)
            HStack {
                Text("Tags:")
                    .bold()
                    .font(.caption)
                if community.tags.count > 0 {
                    ForEach(community.tags, id: \.self) { itemTag in
                        Button {
                        } label: {
                            Text(itemTag)
                                .padding(.horizontal, 5)
                        }
                        .disabled(true)
                        .buttonStyle(.lightBordered)
                        .font(.caption)
                    }
                } else {
                    Text("none")
                        .font(.caption2)
                }
                Spacer()
            }
            .padding(.horizontal)
            .padding(.bottom)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct CommunityJoinButton: View {
    @EnvironmentObject private var authenticationService: AuthenticationService
    @EnvironmentObject private var webClient: ClientContainer
    @ObservedObject private var requestState: RequestState = RequestState()
    
    @State private var isJoined: Bool
    @State private var task: Task<Void, Never>? = nil

    let communityName: String
    
    init(_ initialValue: Bool, for community: String) {
        self.isJoined = initialValue
        self.communityName = community
    }
    
    var body: some View {
        HStack {
            Spacer()
            Button {
                task?.cancel()
                task = Task.detached(priority: .background) {
                    if await !isJoined {
                        await requestState.wrap {
                            try await webClient.forumClient.joinCommunity(with: communityName)
                        }
                        await MainActor.run {
                            isJoined = true
                            task?.cancel()
                        }
                    } else {
                        await requestState.wrap {
                            try await webClient.forumClient.leaveCommunity(with: communityName)
                        }
                        await MainActor.run {
                            isJoined = false
                            task?.cancel()
                        }
                    }
                }
            } label: {
                switch requestState.state {
                    case .loading:
                        ProgressView()
                            .progressViewStyle(.circular)
                            .frame(minWidth: 78)
                            .foregroundColor(.primary)
                    case .done, .failed:
                        Text(isJoined ? "Leave" : "Join")
                            .padding(.horizontal)
                }
            }
            .buttonStyle(.borderedProminent)
            .disabled(requestState.state == .loading || !authenticationService.state.isAuthorized)
        }
        .onAppear {
            requestState.state = .done
        }
        .onDisappear {
            task?.cancel()
        }
    }
}

struct CommunityView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            AttachStubEnvironmentObjects {
                CommunityView(communityName: "Name")
            }
        }
    }
}
