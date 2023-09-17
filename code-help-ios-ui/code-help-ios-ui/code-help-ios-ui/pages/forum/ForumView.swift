//
//  ForumView.swift
//  code-help-ios-ui
//
//  Created by Martin Trajkovski on 30.8.23.
//

import SwiftUI
import ForumApi
import Authentication

struct ForumView: View {
    typealias RefreshAction = () -> Void
    @State var refreshPosts: RefreshAction? = nil
    
    var body: some View {
        NavigationTitleView(title: "Forum") {
            ScrollView {
                ForumPosts() { refresh in
                    refreshPosts = refresh
                }
            }
            .refreshable {
                refreshPosts?()
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink {
                        CommunityDiscover()
                    } label: {
                        Image(systemName: "magnifyingglass")
                    }
                }
            }
        }
    }
}


struct ForumPosts: View {
    typealias RefreshTrigger = () -> Void
    typealias AppearAction = (@escaping RefreshTrigger) -> Void
    typealias Action = () -> Void
    
    @EnvironmentObject private var webClient: ClientContainer
    @EnvironmentObject private var authenticationService: AuthenticationService
    @State private var deleteTask: Task<Void, Never>? = nil
    @State private var updateTask: Task<Void, Never>? = nil
    
    var appeared: AppearAction?
    let communityName: String?
    
    init(communityName: String? = nil, appeared: ((@escaping RefreshTrigger) -> Void)? = nil) {
        self.communityName = communityName
        self.appeared = appeared
    }
    
    func getDeletePost(postId: String, after postAction: @escaping () -> Void) -> Action? {
        if !authenticationService.state.isAuthorized {
            return nil
        }
        
        return {
            deleteTask?.cancel()
            Task.detached {
                do {
                    let _ = try await webClient.forumClient.deletePost(with: postId)
                    postAction()
                } catch {
                    print(error)
                }
                
                await deleteTask?.cancel()
            }
        }
    }
    
    func getUpdatePost(postId: String, after postAction: @escaping () -> Void) -> Action? {
        if authenticationService.state.isAuthorized {
            return nil
        }
        
        return {
            deleteTask?.cancel()
            Task.detached {
                do {
                    let _ = try await webClient.forumClient.updatePost(for: postId, with: .init(title: "", content: ""))
                    postAction()
                } catch {
                    print(error)
                }
                
                await deleteTask?.cancel()
            }
        }
    }
    
    var body: some View {
        VStack {
            RequestDataFallback { posts, refresh in
                ForEach(posts, id: \.uid) { post in
                    NavigationLink {
                        ForumPostView(postUid: post.uid)
                    } label: {
                        ForumPostCard(post: post.toPostCardModel(), delete: getDeletePost(postId: post.uid, after: refresh))
                    }
                    .buttonStyle(.plain)
                    Spacer(minLength: 20)
                }
                .onAppear {
                    appeared?(refresh)
                }
            } suplier: {
                return try await webClient.forumClient.getPosts(in: communityName)
            }
            .padding()
        }
    }
}

struct ForumView_Previews: PreviewProvider {
    static var previews: some View {
        AttachEnvironmentObjects {
            ForumView()
        }
    }
}
